package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;
import ru.softdepot.FileStorageService;
import ru.softdepot.core.models.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Repository
public class ProgramDAO implements DAO<Program> {
    private static DeveloperDAO developerDAO = new DeveloperDAO();
    private static CategoryDAO categoryDAO = new CategoryDAO();
    private static DegreeOfBelongingDAO degreeOfBelongingDAO = new DegreeOfBelongingDAO();
    private static ReviewDAO reviewDAO = new ReviewDAO();
    private static CartDAO cartDAO = new CartDAO();
    private static CustomerDAO customerDAO = new CustomerDAO();
    private static ProgramDAO programDAO = new ProgramDAO();

    private static Connection connection;

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try {
            connection = DriverManager.getConnection(DataBase.getUrl(), DataBase.getUser(), DataBase.getPassword());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private static Double getEuclideanDistance(List<Double> a, List<Double> b) {
        Double sum = 0.0;

        for (var i = 0; i < a.size(); i++) {
            sum += Math.pow(a.get(i) - b.get(i), 2);
        }

        return Math.sqrt(sum);
    }

    private static List<Double> getDegreesOfBelonging(Program program, List<Category> allCategories) {
        List<Double> degreesOfBelonging = new ArrayList<>();

        for (int i = 0; i < allCategories.size(); i++) {
            degreesOfBelonging.add(0.0);
        }

        var categoriesOfProgram = programDAO.getCategories(program.getId());

        for (var category : categoriesOfProgram) {
            int id = allCategories.indexOf(category);
            double dob = category.getDegreeOfBelonging();
            degreesOfBelonging.set(id, dob);
        }

        return degreesOfBelonging;
    }

    public Program setAdditionalInfo(Customer customer, Program program) {
        program.setIsInCart(programDAO.isInCart(program, customer));
        program.setIsPurchased(programDAO.isPurchased(program, customer));
        program.setHasReview(programDAO.hasReview(program, customer));

        return program;
    }

    private Program resultSetToProgram(ResultSet resultSet) throws SQLException {
        Program program = new Program(
                resultSet.getInt("id"),
                resultSet.getString("program_name"),
                resultSet.getBigDecimal("price"),
                resultSet.getString("description"),
                resultSet.getInt("developer_id"),
                resultSet.getString("short_description"),
                getCategories(resultSet.getInt("id")),
                resultSet.getString("logo_url"),
                null
        );
        var screenshots = resultSet.getArray("screenshots_url");
        if (screenshots != null) {
            program.setScreenshotsUrls(Arrays.asList((String[]) screenshots.getArray()));
        }
        program.setHeaderUrl();
        program.setAverageEstimation(getAverageEstimation(program));
        return program;
    }

    public void addMedia(FileStorageService fileStorageService, int programId, Program program, MultipartFile logo, List<MultipartFile> screenshots) throws IOException {
        var logoPath = fileStorageService.saveFile(
                logo,
                program.getFilesPath(fileStorageService.getMediaUploadDir())
        );

        List<String> screenshotsUrls = new ArrayList<>();
        for (var screenshot : screenshots) {
            var screenshotPath = fileStorageService.saveFile(
                    screenshot,
                    program.getFilesPath(fileStorageService.getMediaUploadDir())
            );
            screenshotsUrls.add(fileStorageService.convertToPublicFilePath(screenshotPath));
        }

        program.setId(programId);
        program.setLogoUrl(fileStorageService.convertToPublicFilePath(logoPath));
        program.setScreenshotsUrls(screenshotsUrls);

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "UPDATE program SET logo_url = ?, screenshots_url=? WHERE id = ?"
            );
            var screenshotsSqlArray = connection.createArrayOf(
                    "TEXT",
                    screenshotsUrls.toArray()
            );
            statement.setString(1, program.getLogoUrl());
            statement.setArray(2, screenshotsSqlArray);
            statement.setInt(3, programId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    @Override
    public int add(Program program) {
        if (!exists(program.getName(), program.getDeveloperId())) {
            try {
                PreparedStatement statement = connection.prepareStatement(
                        "INSERT INTO program (program_name, price, description, developer_id, short_description) " +
                                "VALUES (?, ?, ?, ?, ?) RETURNING id"
                );

                statement.setString(1, program.getName());
                statement.setBigDecimal(2, program.getPrice());
                statement.setString(3, program.getFullDescription());
                statement.setInt(4, program.getDeveloperId());
                statement.setString(5, program.getShortDescription());

                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    program.setId(resultSet.getInt("id"));
                    var categories = program.getCategories();
                    for (var category : categories) {
                        degreeOfBelongingDAO.add(new DegreeOfBelonging(
                                program.getId(),
                                category.getId(),
                                category.getDegreeOfBelonging()
                        ));
                    }
                    return program.getId();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            String msg = String.format("Program [name=%s, developer_id=%d] already exists",
                    program.getName(), program.getDeveloperId());
        }
        return -1;
    }

    @Override
    public void update(Program program) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "UPDATE program SET program_name=?, price=?, description=?, developer_id=? " +
                            "WHERE id=?"
            );

            statement.setString(1, program.getName());
            statement.setBigDecimal(2, program.getPrice());
            statement.setString(3, program.getFullDescription());
            statement.setInt(4, program.getDeveloperId());
            statement.setInt(5, program.getId());

            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM program WHERE id=?"
            );
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Program getById(int id) throws Exception {
        Program program = null;
        try {
            PreparedStatement statement =
                    connection.prepareStatement("SELECT * FROM program WHERE id = ?");
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                program = resultSetToProgram(resultSet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (program == null) {
            String msg = String.format("Program [id=%d] does not exist", id);
            throw new Exception(msg);
        }

        return program;
    }

    public Program getByNameAndDeveloperId(String programName, int developerId) throws Exception {
        Program program = null;

        PreparedStatement statement = null;
        try {
            statement = connection.prepareStatement(
                    "SELECT * FROM program WHERE program_name=? AND developer_id=?"
            );
            statement.setString(1, programName);
            statement.setInt(2, developerId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                //Преобразование java.sql.Array в List<URL>
//                Array tempSqlArray = resultSet.getArray("screenshots_url");
//                List<String> screenshotsUrlList = new ArrayList<>();
//                if (tempSqlArray != null) {
//                    String[] screenshotsUrlStrArr = (String[])tempSqlArray.getArray();
//                    screenshotsUrlList = Arrays.stream(screenshotsUrlStrArr).toList();
//                }

                program = new Program(
                        resultSet.getInt("id"),
                        resultSet.getString("program_name"),
                        resultSet.getBigDecimal("price"),
                        resultSet.getString("description"),
                        resultSet.getInt("developer_id"),
                        resultSet.getString("short_description"),
                        getCategories(resultSet.getInt("id")),
                        resultSet.getString("logo_url"),
                        (String[]) resultSet.getArray("screenshots_url").getArray()
                );
                program.setHeaderUrl();
                program.setAverageEstimation(getAverageEstimation(program));
                return program;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        String msg = String.format("The program [name=%s, developer_id=%d] does not exist",
                programName, developerId);
        throw new Exception(msg);
    }

    public List<Program> getAll() {
        List<Program> programs = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM program"
            );
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                var program = resultSetToProgram(resultSet);
                programs.add(program);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return programs;
    }

    public List<Program> getSeveral(int startNum, int amount) {
        List<Program> programs = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM program LIMIT ? OFFSET ?"
            );
            statement.setInt(1, amount);
            statement.setInt(2, startNum);

            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                //Преобразование java.sql.Array в List<URL>
//                Array tempSqlArray = resultSet.getArray("screenshots_url");
//                List<String> screenshotsUrlList = new ArrayList<>();
//                if (tempSqlArray != null) {
//                    String[] screenshotsUrlStrArr = (String[])tempSqlArray.getArray();
//                    screenshotsUrlList = Arrays.stream(screenshotsUrlStrArr).toList();
//                }


                Program program = resultSetToProgram(resultSet);
                programs.add(program);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return programs;
    }

    public List<Program> getByName(String programName) {
        List<Program> programs = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM program WHERE program_name=?"
            );
            statement.setString(1, programName);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                //Преобразование java.sql.Array в List<URL>
                Array tempSqlArray = resultSet.getArray("screenshots_url");
                List<String> screenshotsUrlList = new ArrayList<>();
                if (tempSqlArray != null) {
                    String[] screenshotsUrlStrArr = (String[]) tempSqlArray.getArray();
                    screenshotsUrlList = Arrays.stream(screenshotsUrlStrArr).toList();
                }

                Program program = resultSetToProgram(resultSet);
                programs.add(program);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return programs;
    }

    public int addTag(int programId, int tagId, int degreeOfBelongingValue) throws Exception {
        if (!hasTag(programId, tagId)) {
            DegreeOfBelonging degreeOfBelongingNew = new DegreeOfBelonging();

            degreeOfBelongingNew.setTagId(tagId);
            degreeOfBelongingNew.setDegreeOfBelongingValue(degreeOfBelongingValue);
            degreeOfBelongingNew.setProgramId(programId);

            return degreeOfBelongingDAO.add(degreeOfBelongingNew);
        } else {
            String msg = String.format("The program [id=%d] already has a degree of belonging  " +
                    "to this tag [id=%d]", programId, tagId);
            throw new Exception(msg);
        }
    }

    public void removeTag(int programId, int tagId) throws Exception {
        Category category = categoryDAO.getById(tagId);
        DegreeOfBelonging degreeOfBelonging = degreeOfBelongingDAO.getByTagAndProgram(tagId, programId);
        if (degreeOfBelonging == null) {
            throw new Exception("The program does not have a degree of belonging to this tag");
        } else {
            degreeOfBelongingDAO.delete(degreeOfBelonging.getId());
        }
    }

    public void updateTag(int programId, int tagId, int degreeOfBelongingValue) throws Exception {
        Category category = categoryDAO.getById(tagId);
        DegreeOfBelonging degreeOfBelonging = degreeOfBelongingDAO.getByTagAndProgram(tagId, programId);
        if (degreeOfBelonging == null) {
            throw new Exception("The program does not have a degree of belonging to this tag");
        } else {
            DegreeOfBelonging degreeOfBelongingNew = new DegreeOfBelonging(degreeOfBelonging.getId());
            degreeOfBelongingNew.setDegreeOfBelongingValue(degreeOfBelongingValue);
            degreeOfBelongingDAO.update(degreeOfBelonging);
        }
    }

    public boolean hasTag(int programId, int tagId) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM degree_of_belonging WHERE " +
                            "program_id=? AND tag_id=?"
            );
            statement.setInt(1, programId);
            statement.setInt(2, tagId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Category> getCategories(int programId) {
        List<DegreeOfBelonging> degreeOfBelongingList = degreeOfBelongingDAO.getAllForProgram(programId);
        List<Category> categoryList = new ArrayList<>();

        for (DegreeOfBelonging degreeOfBelonging : degreeOfBelongingList) {
            Category category = categoryDAO.getById(degreeOfBelonging.getTagId());
            category.setDegreeOfBelonging(degreeOfBelonging.getDegreeOfBelongingValue());
            category.setProgramId(degreeOfBelonging.getProgramId());
            categoryList.add(category);
        }

        return categoryList;
    }

    public boolean exists(String programName, int developerId) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM program WHERE program_name=? AND developer_id=?"
            );
            statement.setString(1, programName);
            statement.setInt(2, developerId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean exists(int programId) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM program WHERE id=?"
            );
            statement.setInt(1, programId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Review> getAllReviews(Program program) throws Exception {
        return reviewDAO.getAllAboutProgram(program.getId());
    }

    public float getAverageEstimation(Program program) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT AVG(estimation) FROM review WHERE program_id=?"
            );
            statement.setInt(1, program.getId());
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getFloat("avg");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean isInCart(Program program, Customer customer) {
        return cartDAO.containsProgram(customer.getId(), program.getId());
    }

    public boolean isPurchased(Program program, Customer customer) {
        List<Program> purchasedPrograms;
        try {
            purchasedPrograms = customerDAO.getPurchasedPrograms(customer);
            for (var p : purchasedPrograms) {
                if (p.getId() == program.getId()) {
                    return true;
                }
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return false;
    }

    public boolean hasReview(Program program, Customer customer) {
        boolean result = false;
        try {
            var review = reviewDAO.get(customer.getId(), program.getId());
            if (review != null) {
                result = true;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    public List<Program> getRecommendations(Customer customer, double minEstimation, double maxPrice) {
        var allPrograms = programDAO.getAll();
        var allCategories = categoryDAO.getAll(CategoryDAO.Sort.DEFAULT);
        var purchasedPrograms = customerDAO.getPurchasedPrograms(customer);
        var recommendations = new ArrayList<Recommendation>();

        //Отладочная информация
        StringBuilder resultCsv = new StringBuilder();
        resultCsv
                .append("Название программы;")
                .append("Стоимость;")
                .append("Средняя оценка;")
                .append("Евклидово расстояние;")
                .append(String.join(
                        ";",
                        allCategories
                                .stream()
                                .map(c->c.getName()).toList()
                        )
                )
                .append("\n");


        var categoriesOfPurchasedPrograms = new ArrayList<Category>();
        //dob - degree of belonging (степень принадлежности)
        var avgDobsOfPurchasedPrograms = new ArrayList<Double>();

        //Подсчет средних степеней принадлежности всех приобретенных программ
        for (var category : allCategories) {
            double avgDob = 0;

            for (var program : purchasedPrograms) {
                if (program.getCategories().contains(category)) {
                    var dob = program
                            .getCategories()
                            .stream()
                            .filter(c -> c.equals(category))
                            .findFirst()
                            .get()
                            .getDegreeOfBelonging();
                    avgDob += dob;
                }
            }

            avgDob /= purchasedPrograms.size();
            avgDobsOfPurchasedPrograms.add(avgDob);
        }

        resultCsv
                .append("Приобретенные программы;;;;")
                .append(";".repeat(allCategories.size()))
                .append(";\n");

        //Составление списка категорий приобретенных программ
        for (var program : purchasedPrograms) {
            var categories = program.getCategories();
            for (var category : categories) {
                if (!categoriesOfPurchasedPrograms.contains(category)) {
                    categoriesOfPurchasedPrograms.add(category);
                }
            }

            StringBuilder resultRow = new StringBuilder();
            resultRow
                    .append(program.getName()).append(";")
                    .append(program.getPrice()).append(";")
                    .append(program.getAverageEstimation()).append(";")
                    .append(" ").append(";")
                    .append(String.join(";", getDegreesOfBelonging(program,allCategories)
                                    .stream()
                                    .map(Object::toString)
                                    .collect(Collectors.toList())
                            )
                    )
                    .append(";\n");
            resultCsv.append(resultRow);
        }

        resultCsv
                .append("Средние значения степеней принадлежности к категориям приобретенных программ;;;;")
                .append(String.join(";",avgDobsOfPurchasedPrograms
                        .stream()
                        .map(Object::toString)
                        .collect(Collectors.toList())))
                .append(";\n");

        /*
        Подсчет евклидова расстояния между степенями принадлежности программ в каталоге и средних степеней
        принадлежности всех приобретенных программ, и добавление программы в список рекомендаций в случае если она:
        1. Имеет общие категории с приобретенными программами
        2. Цена ниже или равна максимально допустимой
        3. Средняя оценка выше или равна минимально допустимой
        */
        for (var program : allPrograms) {
            var degreesOfBelonging = getDegreesOfBelonging(program,allCategories);
            var distance = getEuclideanDistance(
                    avgDobsOfPurchasedPrograms,
                    degreesOfBelonging
            );

            boolean hasCommonCategories = false;

            for (var categoryOfProgram : program.getCategories()) {
                if (categoriesOfPurchasedPrograms.contains(categoryOfProgram)) {
                    hasCommonCategories = true;
                    break;
                }
            }

            boolean estimationIsGood = program.getAverageEstimation() >= minEstimation;
            boolean priceIsGood = program.getPrice().compareTo(BigDecimal.valueOf(maxPrice)) <= 0;
            boolean notPurchased = !purchasedPrograms.contains(program);

            if (hasCommonCategories && estimationIsGood && priceIsGood && notPurchased) {
                recommendations.add(new Recommendation(program, distance, degreesOfBelonging));
            }
        }

        //Сортировка списка рекомендаций по возрастанию евклидова расстояния
        Collections.sort(recommendations, new RecommendationsComparator());

        //Итоговый список программ
        var result = recommendations
                .stream()
                .map(r -> setAdditionalInfo(customer, r.program()))
                .toList();

        //Отладочная информация
        resultCsv
                .append("Рекомендуемые к покупке программы;;;;")
                .append(";".repeat(allCategories.size()))
                .append(";\n");
        for (var r : recommendations) {
            var program = r.program();
            StringBuilder resultRow = new StringBuilder();
            resultRow
                    .append(program.getName()).append(";")
                    .append(program.getPrice()).append(";")
                    .append(program.getAverageEstimation()).append(";")
                    .append(r.euclideanDistance()).append(";")
                    .append(String.join(";", r.degreesOfBelonging()
                                    .stream()
                                    .map(Object::toString)
                                    .collect(Collectors.toList())
                            )
                    )
                    .append(";\n");
            resultCsv.append(resultRow);
        }

        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);
        int hour = calendar.get(Calendar.HOUR_OF_DAY);
        int minute = calendar.get(Calendar.MINUTE);
        int second = calendar.get(Calendar.SECOND);
        String dateTime = String.format("%d-%02d-%02d %02d-%02d-%02d",
                year, month, dayOfMonth, hour, minute, second);

        Path filePath = null;
        try {
            filePath = Files.createFile(Path.of("logs/" + dateTime + ".csv").toAbsolutePath());
            Files.writeString(filePath, resultCsv);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        return result;
    }
}

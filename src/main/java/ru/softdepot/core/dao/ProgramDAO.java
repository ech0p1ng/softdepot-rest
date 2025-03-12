package ru.softdepot.core.dao;

import com.fasterxml.jackson.databind.ObjectMapper;
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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

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

    private static Double getEuclideanDistance(List<Double> a, List<Double> b) {
        Double sum = 0.0;

        for (var i = 0; i < a.size(); i++) {
            sum += Math.pow(a.get(i) - b.get(i), 2);
        }

        return Math.sqrt(sum);
    }

    private static List<Double> getDegreesOfBelonging(Program program, int lastCategoryId) {
        List<Double> degreesOfBelonging = new ArrayList<>();
        for (int i = 0; i <= lastCategoryId; i++) {
            degreesOfBelonging.add(0.0);
        }
        var categories = programDAO.getCategories(program.getId());

        for (var category : categories) {
            degreesOfBelonging.add(
                    category.getId(),
                    (double) category.getDegreeOfBelonging()
            );
        }
        return degreesOfBelonging;
    }

    public void addMedia(FileStorageService fileStorageService, int programId, Program program, MultipartFile logo, List<MultipartFile> screenshots) throws IOException {
        program.setId(programId);
        var logoPath = fileStorageService.saveFile(
                logo,
                program.getFilesPath(fileStorageService.getMediaUploadDir())
        );
        program.setLogoUrl(fileStorageService.convertToPublicFilePath(logoPath));

        List<String> screenshotsUrls = new ArrayList<>();
        for (var screenshot : screenshots) {
            var screenshotPath = fileStorageService.saveFile(
                    screenshot,
                    program.getFilesPath(fileStorageService.getMediaUploadDir())
            );
            screenshotsUrls.add(fileStorageService.convertToPublicFilePath(screenshotPath));
        }
        program.setScreenshotsUrls(screenshotsUrls);

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "UPDATE program SET logo_url = ?, screenshots_url=? WHERE id = ?"
            );
            var screenshotsSqlArray = connection.createArrayOf(
                    "VARCHAR",
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

    public List<Program> getRecommendations(Customer customer, double minEstimation, double maxPrice) throws Exception {
        var allPrograms = programDAO.getAll();

        List<Program> purchasedPrograms = null;
        try {
            purchasedPrograms = customerDAO.getPurchasedPrograms(customer);
        } catch (Exception e) {
            throw new Exception("У покупателя с id=" + customer.getId() + " не найдено приобретенных программ");
        }

        var allCategories = categoryDAO.getAll(CategoryDAO.Sort.DEFAULT);
        int lastId = allCategories.getLast().getId();

        //dob - degree of belonging
        List<List<Double>> purchasedProgramsDob = new ArrayList<>();

        for (var purchasedProgram : purchasedPrograms) {
            purchasedProgramsDob.add(
                    getDegreesOfBelonging(purchasedProgram, lastId)
            );
        }

        //средняя степень принадлежности к каждой программе в библиотеке
        List<Double> avgDegreesOfBelonging = new ArrayList<>();

        for (int categoryId = 0; categoryId <= lastId; categoryId++) {
            double avgDegreeOfBelonging = 0.0;
            for (int programsDobId = 0; programsDobId < purchasedProgramsDob.size(); programsDobId++) {
                avgDegreeOfBelonging += purchasedProgramsDob.get(programsDobId).get(categoryId);
            }
            avgDegreeOfBelonging /= lastId;
            avgDegreesOfBelonging.add(avgDegreeOfBelonging);
        }

        //Составление списка рекомендаций
        List<Recommendation> recommendations = new ArrayList<>();

        for (var program : allPrograms) {
            var degreesOfBelonging = getDegreesOfBelonging(program, lastId);
            var distance = getEuclideanDistance(
                    avgDegreesOfBelonging,
                    degreesOfBelonging
            );

            boolean priceIsGood = program.getPrice().compareTo(new BigDecimal(maxPrice)) <= 0;
            boolean estimationIsGood = program.getAverageEstimation() >= minEstimation;

            if (estimationIsGood && priceIsGood) {
                recommendations.add(new Recommendation(
                        program,
                        distance
                ));
            }
        }

        recommendations.sort(new RecommendationsComparator());
        if (recommendations.size() > 100)
            recommendations = recommendations.subList(0, 100);
        List<Program> result = new ArrayList<>();
        for (var recommendation : recommendations) {
            result.add(recommendation.program());
        }

        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);
        int hour = calendar.get(Calendar.HOUR_OF_DAY);  // Для 24-часового формата
        int minute = calendar.get(Calendar.MINUTE);
        int second = calendar.get(Calendar.SECOND);
        String dateTime = String.format("%d-%02d-%02d %02d-%02d-%02d",
                year, month, dayOfMonth, hour, minute, second);

        ObjectMapper objectMapper = new ObjectMapper();
        String resultJson = objectMapper
                .writerWithDefaultPrettyPrinter()
                .writeValueAsString(
                        new RecommendationResult(
                                customer,
                                allPrograms,
                                recommendations,
                                dateTime
                        )
                );

        var filePath = Files.createFile(Path.of("logs/" + dateTime + ".log").toAbsolutePath());
        Files.writeString(filePath, resultJson);

        return result;
    }
}

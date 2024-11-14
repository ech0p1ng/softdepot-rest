package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import ru.softdepot.core.models.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Component
@Repository
public class ProgramDAO implements DAO<Program> {
    private static DeveloperDAO developerDAO = new DeveloperDAO();
    private static CategoryDAO categoryDAO = new CategoryDAO();
    private static DegreeOfBelongingDAO degreeOfBelongingDAO = new DegreeOfBelongingDAO();
    private static ReviewDAO reviewDAO = new ReviewDAO();
    private static CartDAO cartDAO = new CartDAO();

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
                    return resultSet.getInt("id");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        else {
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
                        getTags(resultSet.getInt("id"))
                );

                program.setHeaderUrl();
                program.setAverageEstimation(getAverageEstimation(program));

                //Преобразование java.sql.Array в List<URL>
//                Array tempSqlArray = resultSet.getArray("screenshots_url");
//                String[] screenshotsUrlStrArr = (String[])tempSqlArray.getArray();
//                List<String> screenshotsUrlList = Arrays.stream(screenshotsUrlStrArr).toList();
//                program.setHeaderUrl(resultSet.getString("header_url"));
//                program.setLogoUrl(resultSet.getString("logo_url"));
//
//                program.setScreenshotsUrl(screenshotsUrlList);
//                program.setAverageEstimation(getAverageEstimation(program));
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
                        getTags(resultSet.getInt("id"))
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
                //Преобразование java.sql.Array в List<URL>
//                Array tempSqlArray = resultSet.getArray("screenshots_url");
//                List<String> screenshotsUrlList = new ArrayList<>();
//                if (tempSqlArray != null) {
//                    String[] screenshotsUrlStrArr = (String[])tempSqlArray.getArray();
//                    screenshotsUrlList = Arrays.stream(screenshotsUrlStrArr).toList();
//                }


                Program program = new Program(
                        resultSet.getInt("id"),
                        resultSet.getString("program_name"),
                        resultSet.getBigDecimal("price"),
                        resultSet.getString("description"),
                        resultSet.getInt("developer_id"),
                        resultSet.getString("short_description"),
                        getTags(resultSet.getInt("id"))
                );
                program.setHeaderUrl();
                program.setAverageEstimation(getAverageEstimation(program));
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


                Program program = new Program(
                        resultSet.getInt("id"),
                        resultSet.getString("program_name"),
                        resultSet.getBigDecimal("price"),
                        resultSet.getString("description"),
                        resultSet.getInt("developer_id"),
                        resultSet.getString("short_description"),
                        getTags(resultSet.getInt("id"))
                );
                program.setHeaderUrl();
                program.setAverageEstimation(getAverageEstimation(program));
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
                    String[] screenshotsUrlStrArr = (String[])tempSqlArray.getArray();
                    screenshotsUrlList = Arrays.stream(screenshotsUrlStrArr).toList();
                }

                Program program = new Program(
                        resultSet.getInt("id"),
                        resultSet.getString("program_name"),
                        resultSet.getBigDecimal("price"),
                        resultSet.getString("description"),
                        resultSet.getInt("developer_id"),
                        resultSet.getString("short_description"),
                        getTags(resultSet.getInt("id"))
                );
                program.setHeaderUrl();
                program.setAverageEstimation(getAverageEstimation(program));
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

    public List<Category> getTags(int programId)  {
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

    public List<Review> getAllReviews(Program program) {
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
}

package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import ru.softdepot.core.models.DegreeOfBelonging;
import ru.softdepot.core.models.Program;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component
@Repository
public class DegreeOfBelongingDAO implements DAO<DegreeOfBelonging> {
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
    public int add(DegreeOfBelonging deegreeOfBelonging) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "INSERT INTO degree_of_belonging (program_id, tag_id, degree_value) " +
                            "VALUES (?, ?, ?) RETURNING id"
            );
            preparedStatement.setInt(1, deegreeOfBelonging.getProgramId());
            preparedStatement.setInt(2, deegreeOfBelonging.getTagId());
            preparedStatement.setDouble(3, deegreeOfBelonging.getDegreeOfBelongingValue());
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public void update(DegreeOfBelonging deegreeOfBelonging) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "UPDATE degree_of_belonging SET program_id=?, tag_id=?, degree_value=? WHERE id=?"
            );
            statement.setInt(1, deegreeOfBelonging.getProgramId());
            statement.setInt(2, deegreeOfBelonging.getTagId());
            statement.setFloat(3, deegreeOfBelonging.getDegreeOfBelongingValue());
            statement.setInt(4, deegreeOfBelonging.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM degree_of_belonging WHERE id=?"
            );
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean exists(int programId, int tagId) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(
                "SELECT * FROM degree_of_belonging WHERE program_id=? AND tag_id=?"
            );
            preparedStatement.setInt(1, programId);
            preparedStatement.setInt(2, tagId);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public DegreeOfBelonging getById(int id) {
        DegreeOfBelonging degreeOfBelonging = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM degree_of_belonging WHERE id=?"
            );
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                degreeOfBelonging = new DegreeOfBelonging(resultSet.getInt("id"));
                degreeOfBelonging.setProgramId(resultSet.getInt("program_id"));
                degreeOfBelonging.setTagId(resultSet.getInt("tag_id"));
                degreeOfBelonging.setDegreeOfBelongingValue(resultSet.getInt("degree_value"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return degreeOfBelonging;
    }

    public DegreeOfBelonging getByTagAndProgram(int tagId, int programId) {
        DegreeOfBelonging degreeOfBelonging = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM degree_of_belonging WHERE tag_id=? AND program_id=?"
            );
            statement.setInt(1, tagId);
            statement.setInt(2, programId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                degreeOfBelonging = new DegreeOfBelonging(resultSet.getInt("id")
                );
                degreeOfBelonging.setProgramId(resultSet.getInt("program_id"));
                degreeOfBelonging.setTagId(resultSet.getInt("tag_id"));
                degreeOfBelonging.setDegreeOfBelongingValue(resultSet.getInt("degree_value"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return degreeOfBelonging;
    }

    public List<DegreeOfBelonging> getAllForProgram(int id) {
        List<DegreeOfBelonging> degreeOfBelongingList = new ArrayList<>();

        try {
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "SELECT * FROM degree_of_belonging WHERE program_id=?"
            );
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                DegreeOfBelonging degreeOfBelonging = new DegreeOfBelonging(
                        resultSet.getInt("id"),
                        resultSet.getInt("program_id"),
                        resultSet.getInt("tag_id"),
                        resultSet.getInt("degree_value")
                );
                degreeOfBelongingList.add(degreeOfBelonging);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return degreeOfBelongingList;
    }
}

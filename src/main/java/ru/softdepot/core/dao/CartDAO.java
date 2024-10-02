package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import ru.softdepot.core.models.Program;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component
@Service
public class CartDAO {
    private static Connection connection;
    private ProgramDAO programDAO = new ProgramDAO();

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

    public List<Program> getPrograms(int customerId){
        List<Program> programs = new ArrayList<Program>();

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT program_id FROM cart WHERE customer_id=?"
            );
            statement.setInt(1, customerId);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int programId = resultSet.getInt("program_id");
                try {
                    Program program = programDAO.getById(programId);
                    programs.add(program);
                }
                catch (Exception e) {}
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return programs;
    }

    public void deleteProgram(int customerId, int programId){
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM cart WHERE program_id=? AND customer_id=?"
            );
            statement.setInt(1, programId);
            statement.setInt(2, customerId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addProgram(int customerId, int programId){
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO cart(customer_id, program_id) VALUES (?,?)"
            );
            statement.setInt(1, customerId);
            statement.setInt(2, programId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean containsProgram(int customerId, int programId) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM cart WHERE program_id=? AND customer_id=?"
            );
            statement.setInt(1, programId);
            statement.setInt(2, customerId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}

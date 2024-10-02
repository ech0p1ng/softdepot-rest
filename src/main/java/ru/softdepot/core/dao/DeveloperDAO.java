package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import ru.softdepot.core.models.DailyStats;
import ru.softdepot.core.models.Developer;
import ru.softdepot.core.models.Program;

import java.sql.*;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

@Component
@Repository
public class DeveloperDAO implements DAO<Developer> {
    ProgramDAO programDAO = new ProgramDAO();
    DailyStatsDAO dailyStatsDAO = new DailyStatsDAO();

    private static Connection connection;

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try {
            connection = DriverManager.getConnection(DataBase.getUrl(), DataBase.getDeveloperRole(), DataBase.getDeveloperPassword());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int add(Developer developer) throws Exception {
        if (!exists(developer.getEmail(), developer.getName())) {
            try {
                PreparedStatement statment = connection.prepareStatement(
                        "INSERT INTO developer (developer_name, email, password, profile_img_url) " +
                                "VALUES (?,?,?,?) " +
                                "RETURNING id"
                );
                statment.setString(1, developer.getName());
                statment.setString(2, developer.getEmail());
                statment.setString(3, developer.getPassword());
                statment.setString(4, developer.getProfileImgUrl());

                ResultSet resultSet = statment.executeQuery();
                if (resultSet.next()) {
                    return resultSet.getInt("id");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        else {
            String msg = String.format("Developer with [email=%s] or [name=%s] already exists.",
                    developer.getEmail(), developer.getName());
            throw new Exception(msg);
        }
        return -1;
    }

    @Override
    public void update(Developer developer) {
        try {
            String sql = "UPDATE developer SET developer_name=?,email=?,password=?," +
                    "profile_img_url=? WHERE id=?";
            PreparedStatement statement = connection.prepareStatement(sql);

            statement.setString(1, developer.getName());
            statement.setString(2, developer.getEmail());
            statement.setString(3, developer.getPassword());
            statement.setString(4, developer.getProfileImgUrl());
            statement.setInt(5, developer.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM developer WHERE id=?"
            );
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Developer getById(int id) throws Exception {
        Developer developer = null;
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM developer WHERE id=?"
            );
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                developer = new Developer(
                        resultSet.getInt("id"),
                        resultSet.getString("developer_name"),
                        resultSet.getString("email"),
                        resultSet.getString("password"),
                        resultSet.getString("profile_img_url")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (developer == null) {
            String msg  = String.format("Developer with [id=%d] does not exist.", id);
            throw new Exception(msg);
        }
        return developer;
    }

    public Developer getByEmailAndPassword(String email, String password) throws Exception {
        Developer developer = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM developer WHERE email=? AND password=?"
            );
            statement.setString(1, email);
            statement.setString(2, password);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                developer = new Developer(
                        resultSet.getInt("id"),
                        resultSet.getString("developer_name"),
                        resultSet.getString("email"),
                        resultSet.getString("password"),
                        resultSet.getString("profile_img_url")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (developer == null) {
            String msg  = String.format("Developer with [email=%s] does not exist.", email);
            throw new Exception(msg);
        }
        return developer;
    }

    public int addProgram(Program program) {
        program.setDeveloperId(program.getDeveloperId());
        int programId = programDAO.add(program);
        return programId;
    }

    public void deleteProgram(Developer developer, Program program) throws Exception {
        if (developer.getId() == program.getDeveloperId()) {
            programDAO.delete(program.getId());
        } else {
            throw new Exception("You are don't have the rights to remove this program");
        }
    }

    public void updateProgram(Developer developer, Program program) throws Exception {
        if (developer.getId() == program.getDeveloperId()) {
            programDAO.update(program);
        } else {
            throw new Exception("You are don't have the rights to change this program");
        }
    }

    public Program getProgram(Developer developer, int programId) throws Exception {
        Program program = programDAO.getById(programId);
        if (hasProgram(developer, program)){
            return program;
        }
        else {
            String msg = String.format("Developer [id=%d] does not have program [id=%d]",
                    developer.getId(), programId);
            throw new Exception(msg);
        }
    }

    public List<Program> getPrograms(int developerId) throws Exception {
        List<Program> programs = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM program WHERE developer_id=?"
            );
            statement.setInt(1, developerId);
            ResultSet resultSet = statement.executeQuery();
            programs = new ArrayList<Program>();
            while (resultSet.next()) {
                Program program = programDAO.getById(resultSet.getInt("id"));
                programs.add(program);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return programs;
    }

    public List<DailyStats> getStats(int programId, ZonedDateTime start, ZonedDateTime end) {

        if (start.isAfter(end)) {
            throw new IllegalArgumentException("Start date cannot be after end date");
        }
        List<DailyStats> stats = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM daily_stats " +
                    "WHERE program_id=? AND stats_date>=? AND stats_date<=?"
            );

            Timestamp sqlDateStart = Timestamp.from(start.toInstant());
            Timestamp sqlDateEnd = Timestamp.from(end.toInstant());

            statement.setInt(1, programId);
            statement.setTimestamp(2, sqlDateStart);
            statement.setTimestamp(3, sqlDateEnd);

            ResultSet resultSet = statement.executeQuery();

            stats = new ArrayList<>();
            while (resultSet.next()) {
                DailyStats dailyStats = dailyStatsDAO.getById(resultSet.getInt("id"));
                stats.add(dailyStats);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public boolean exists(String email, String developerName) {
        boolean exists = false;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM developer WHERE email=? OR developer_name=?"
            );
            statement.setString(1, email);
            statement.setString(2, developerName);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                exists = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return exists;
    }

    public boolean hasProgram(Developer developer, Program program) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT id FROM program WHERE id=? AND developer_id=?"
            );
            statement.setInt(1, program.getId());
            statement.setInt(2, developer.getId());
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
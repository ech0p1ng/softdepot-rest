package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import ru.softdepot.core.models.DailyStats;
import ru.softdepot.core.models.Program;

import java.sql.*;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Component
@Repository
public class DailyStatsDAO implements DAO<DailyStats> {
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
    public int add(DailyStats dailyStats) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO daily_stats VALUES (stats_date=?, program_id?)" +
                            "RETURNING id"
            );
            Timestamp date = DataBase.convertToTimestamp(dailyStats.getDate());
            statement.setTimestamp(1, date);
            statement.setInt(2, dailyStats.getProgramId());
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return dailyStats.getId();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public void update(DailyStats dailyStats) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "UPDATE daily_stats SET stats_date=?, program_id=? WHERE id=?"
            );
            Timestamp date = DataBase.convertToTimestamp(dailyStats.getDate());
            statement.setTimestamp(1, date);
            statement.setInt(2, dailyStats.getProgramId());
            statement.setInt(3, dailyStats.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM daily_stats WHERE id=?"
            );
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public DailyStats getById(int id) {
        DailyStats dailyStats = null;
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM daily_stats WHERE id=?"
            );
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                OffsetDateTime dateTime = DataBase.convertToDateTime(
                        resultSet.getTimestamp("stats_date"));

                dailyStats = new DailyStats(
                        id,
                        dateTime,
                        resultSet.getInt("program_id"),
                        resultSet.getFloat("avg_estimation"),
                        resultSet.getBigDecimal("earnings"),
                        resultSet.getInt("purchases_amount"),
                        resultSet.getInt("reviews_amount")
                );

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dailyStats;
    }

    public List<DailyStats> getByProgramId(int programId) {
        List<DailyStats> stats = new ArrayList<>();

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM daily_stats WHERE program_id=?"
            );
            statement.setInt(1, programId);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                OffsetDateTime dateTime = DataBase.convertToDateTime(
                        resultSet.getTimestamp("stats_date"));

                stats.add(new DailyStats(
                        resultSet.getInt("id"),
                        dateTime,
                        resultSet.getInt("program_id"),
                        resultSet.getFloat("avg_estimation"),
                        resultSet.getBigDecimal("earnings"),
                        resultSet.getInt("purchases_amount"),
                        resultSet.getInt("reviews_amount")
                ));

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public boolean exists(int statsId) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM daily_stats WHERE id=?"
            );
            statement.setInt(1, statsId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public DailyStats collect(Program program) {
        DailyStats dailyStats = null;

        return dailyStats;
    }
}

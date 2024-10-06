package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import ru.softdepot.core.models.Customer;
import ru.softdepot.core.models.Program;
import ru.softdepot.core.models.Review;

import java.sql.*;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Component
@Repository
public class ReviewDAO implements DAO<Review> {
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
    public int add(Review review) throws Exception {
        if (!exists(review.getCustomerId(), review.getProgramId())) {
            try {
                PreparedStatement statement = connection.prepareStatement(
                        "INSERT INTO review (customer_id, program_id, estimation, review_text, date_time) " +
                                "VALUES (?, ?, ?, ?, ?) RETURNING id"
                );

                statement.setInt(1, review.getCustomerId());
                statement.setInt(2, review.getProgramId());
                statement.setInt(3, review.getEstimation());
                statement.setString(4, review.getReviewText());
                statement.setTimestamp(5, DataBase.convertToTimestamp(review.getDateTime()));

                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    return resultSet.getInt("id");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        else {
            String msg = String.format("Review of customer [id=%d] already exists",
                    review.getCustomerId());
            throw new Exception(msg);
        }
        return -1;
    }

    @Override
    public void update(Review review) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "UPDATE review SET customer_id=?, program_id=?,estimation=?, review_text=?,date_time=? WHERE id=?"
            );
            statement.setInt(1, review.getCustomerId());
            statement.setInt(2, review.getProgramId());
            statement.setInt(3, review.getEstimation());
            statement.setString(4, review.getReviewText());
            statement.setTimestamp(5, DataBase.convertToTimestamp(review.getDateTime()));
            statement.setInt(6, review.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM review WHERE id=?"
            );
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Review getById(int id) {
        Review review = null;
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM review WHERE id=?"
            );
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                OffsetDateTime dateTime =
                        DataBase.convertToDateTime(resultSet.getTimestamp("date_time"));
                review = new Review(
                        id,
                        resultSet.getInt("customer_id"),
                        resultSet.getInt("program_id"),
                        resultSet.getInt("estimation"),
                        resultSet.getString("review_text"),
                        dateTime
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return review;
    }

    public Review get(int customerId, int programId) throws Exception {
        Review review = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM review WHERE customer_id=? AND program_id=?"
            );
            statement.setInt(1, customerId);
            statement.setInt(2, programId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                review = new Review(
                    resultSet.getInt("id"),
                        customerId,
                        programId,
                        resultSet.getInt("estimation"),
                        resultSet.getString("review_text"),
                        DataBase.convertToDateTime(resultSet.getTimestamp("date_time"))
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (review == null) {
            String msg  = String.format("Сustomer [id=%d] review about the program [id=%d] does not exist.",
                    customerId, programId);
            throw new Exception(msg);
        }

        return review;
    }

    public boolean exists(int cutomerId, int programId) {
        boolean exists = false;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM review WHERE customer_id=? AND program_id=?"
            );
            statement.setInt(1, cutomerId);
            statement.setInt(2, programId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                exists = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return exists;
    }

    public boolean exists(int id) {
        boolean exists = false;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM review WHERE id=?"
            );
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                exists = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return exists;
    }

    public List<Review> getAllByCustomer(int customerId) {
        List<Review> reviews = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM review WHERE customer_id=?"
            );
            statement.setInt(1, customerId);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Review review = getById(resultSet.getInt("id"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public List<Review> getAllAboutProgram(int programId) {
        List<Review> reviews = new ArrayList<Review>();
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM review WHERE program_id=?"
            );
            statement.setInt(1, programId);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                reviews.add(getById(resultSet.getInt("id")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

}

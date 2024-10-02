package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import ru.softdepot.core.models.Customer;
import ru.softdepot.core.models.Program;
import ru.softdepot.core.models.Purchase;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component
@Repository
public class PurchaseDAO implements DAO<Purchase> {
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
    public int add(Purchase purchase) {
        if (!exists(purchase.getCustomerId(), purchase.getProgramId())) {
            try {
                PreparedStatement statement = connection.prepareStatement(
                        "INSERT INTO purchase (purchase_date_time, customer_id, program_id) VALUES (?, ?, ?) " +
                                "RETURNING id"
                );
                statement.setTimestamp(1, DataBase.convertToTimestamp(purchase.getDateTime()));
                statement.setInt(2, purchase.getCustomerId());
                statement.setInt(3, purchase.getProgramId());
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    return resultSet.getInt("id");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        else {
            String msg = String.format("Purchase [date=%s, customer_id=%d, program_id=%d] already exists",
                    purchase.getDateTime(), purchase.getCustomerId(), purchase.getProgramId());
            throw new RuntimeException(msg);
        }
        return -1;
    }

    @Override
    public void update(Purchase purchase) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "UPDATE purchase SET purchase_date_time=?, customer_id=?, program_id=? " +
                            "WHERE id=?"
            );

            statement.setTimestamp(1, DataBase.convertToTimestamp(purchase.getDateTime()));
            statement.setInt(2, purchase.getCustomerId());
            statement.setInt(3, purchase.getProgramId());
            statement.setInt(4, purchase.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    @Override
    public void delete(int id) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM purchase WHERE id=?"
            );
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int customerId, int programId) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM purchase WHERE customer_id=? AND program_id=?"
            );
            statement.setInt(1, customerId);
            statement.setInt(2, programId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Purchase getById(int id) {
        Purchase purchase = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM purchase WHERE id=?"
            );
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                purchase = new Purchase(resultSet.getInt("id"));
                Timestamp purchaseTimestamp = resultSet.getTimestamp("purchase_date_time");
                purchase.setDateTime(DataBase.convertToDateTime(purchaseTimestamp));
                purchase.setCustomerId(resultSet.getInt("customer_id"));
                purchase.setProgramId(resultSet.getInt("program_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return purchase;
    }

    public Purchase getByCustomerAndProgram(Customer customer, Program program) {
        Purchase purchase = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM purchase WHERE customer_id=? AND program_id=?"
            );
            statement.setInt(1, customer.getId());
            statement.setInt(2, program.getId());
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                purchase = new Purchase(resultSet.getInt("id"));
                Timestamp purchaseTimestamp = resultSet.getTimestamp("purchase_date_time");
                purchase.setDateTime(DataBase.convertToDateTime(purchaseTimestamp));
                purchase.setCustomerId(resultSet.getInt("customer_id"));
                purchase.setProgramId(resultSet.getInt("program_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return purchase;
    }

    public List<Purchase> getPurchasesOfCustomer(Customer customer) {
        List<Purchase> purchases = new ArrayList<>();

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM purchase WHERE customer_id=?"
            );
            statement.setInt(1, customer.getId());
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Purchase purchase = getById(resultSet.getInt("id"));
                purchases.add(purchase);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return purchases;
    }

    public List<Purchase> getPurchasesOfProgram(Program program) {
        List<Purchase> purchases = new ArrayList<Purchase>();

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM purchase WHERE program_id=?"
            );
            statement.setInt(1, program.getId());
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Purchase purchase = getById(resultSet.getInt("id"));
                purchases.add(purchase);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return purchases;
    }

    public boolean exists(int customerId, int programId) {
        boolean exists = false;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM purchase WHERE customer_id=? AND program_id=?"
            );
            statement.setInt(1, customerId);
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

    public List<Purchase> getAll() {
        List<Purchase> purchases = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM purchase"
            );
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Purchase purchase = getById(resultSet.getInt("id"));
                purchases.add(purchase);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return purchases;
    }
}

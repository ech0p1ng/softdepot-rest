package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import ru.softdepot.core.models.Administrator;
import ru.softdepot.core.models.Customer;
import ru.softdepot.core.models.Developer;
import ru.softdepot.core.models.User;

import java.sql.*;

@Component
@Repository
public class UserDAO implements DAO<User> {
    CustomerDAO customerDAO = new CustomerDAO();
    DeveloperDAO developerDAO = new DeveloperDAO();
    AdministratorDAO administratorDAO = new AdministratorDAO();


    private static Connection connection;

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try {
            connection = DriverManager.getConnection(DataBase.getUrl(), DataBase.getUnregisteredRole(), DataBase.getUnregisteredUserPassword());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int add(User user) throws Exception {
        switch (user.getUserType()) {
            case Customer: {
                return customerDAO.add(new Customer(user));
            }
            case Developer: {
                return developerDAO.add(new Developer(user));
            }
            case Administrator: {
                return administratorDAO.add(new Administrator(user));
            }
        }
        return -1;
    }

    @Override
    public void update(User user) {
        switch (user.getUserType()) {
            case Customer: {
                customerDAO.update((Customer) user);
                break;
            }
            case Developer: {
                developerDAO.update((Developer) user);
                break;
            }
            case Administrator: {
                administratorDAO.update((Administrator) user);
                break;
            }
        }
    }

    @Override
    @Deprecated
    public void delete(int id) throws Exception {
        Customer customer = customerDAO.getById(id);
        Developer developer = developerDAO.getById(id);
        Administrator administrator = administratorDAO.getById(id);

        if (customer != null) {
            customerDAO.delete(id);
        } else if (developer != null) {
            developerDAO.delete(id);
        } else if (administrator != null) {
            administratorDAO.delete(id);
        }
    }

    @Override
    @Deprecated
    public User getById(int id) throws Exception {
        Customer customer = customerDAO.getById(id);
        Developer developer = developerDAO.getById(id);
        Administrator administrator = administratorDAO.getById(id);

        if (customer != null) {
            return customer;
        } else if (developer != null) {
            return developer;
        } else if (administrator != null) {
            return administrator;
        }
        return null;
    }

    public boolean exists(String email) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "SELECT email FROM customer WHERE email=? " +
                            "UNION " +
                            "SELECT email FROM developer WHERE email=? " +
                            "UNION " +
                            "SELECT email FROM administrator WHERE email=?"
            );
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, email);
            preparedStatement.setString(3, email);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


}

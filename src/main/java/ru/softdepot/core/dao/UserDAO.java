package ru.softdepot.core.dao;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import ru.softdepot.core.models.Administrator;
import ru.softdepot.core.models.Customer;
import ru.softdepot.core.models.Developer;
import ru.softdepot.core.models.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserDAO implements DAO<User>, UserDetailsService {
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

        return switch (user.getUserType()) {
            case Customer -> customerDAO.add(new Customer(user));
            case Developer -> developerDAO.add(new Developer(user));
            case Administrator -> administratorDAO.add(new Administrator(user));
        };
//        return -1;
    }

    @Override
    public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
        var user = getByUserName(userName);
        if (user == null) {
            throw new UsernameNotFoundException("User not found by name " + userName);
        }
        List<GrantedAuthority> grantedAuthorities = new ArrayList<>();

        grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_" + user.getUserType().name().toUpperCase()));

        return new org.springframework.security.core.userdetails
                .User(user.getName(), user.getPassword(), grantedAuthorities);
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

    public boolean existsByName(String name) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "SELECT customer_name FROM customer WHERE customer_name=? " +
                            "UNION " +
                            "SELECT developer_name FROM developer WHERE developer_name=? " +
                            "UNION " +
                            "SELECT administrator_name FROM administrator WHERE administrator_name=?"
            );
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, name);
            preparedStatement.setString(3, name);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getByUserName(String userName) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "SELECT password FROM customer WHERE customer_name=? " +
                            "UNION " +
                            "SELECT password FROM developer WHERE developer_name=? " +
                            "UNION " +
                            "SELECT password FROM administrator WHERE administrator_name=?"
            );
            preparedStatement.setString(1, userName);
            preparedStatement.setString(2, userName);
            preparedStatement.setString(3, userName);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return getByNameAndPassword(
                        userName,
                        resultSet.getString("password")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public User getByNameAndPassword(String name, String password) throws Exception {
        var customer = customerDAO.getByNameAndPassword(name, password);
        if (customer != null) return customer;
        var developer = developerDAO.getByNameAndPassword(name, password);
        if (developer != null) return developer;
        var administrator = administratorDAO.getByNameAndPassword(name, password);
        if (administrator != null) return administrator;
        return null;
    }

}

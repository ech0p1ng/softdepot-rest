package ru.softdepot.core.dao;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;
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
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        var user = getByEmail(email);

        List<GrantedAuthority> grantedAuthorities = new ArrayList<>();

        grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_" + user.getUserType().name().toUpperCase()));
//        grantedAuthorities.add(new SimpleGrantedAuthority(user.getUserType().name().toUpperCase()));

        System.out.println(grantedAuthorities.get(0).getAuthority());

        return new org.springframework.security.core.userdetails
                .User(user.getEmail(), user.getPassword(), grantedAuthorities);
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

    public boolean existsByEmail(String email) {
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

    public boolean existsByName(String name) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "SELECT email FROM customer WHERE customer_name=? " +
                            "UNION " +
                            "SELECT email FROM developer WHERE developer_name=? " +
                            "UNION " +
                            "SELECT email FROM administrator WHERE administrator_name=?"
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

    public User getByEmail(String email) {
        try {
            System.out.println(email);
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "SELECT email, password FROM customer WHERE email=? " +
                            "UNION " +
                            "SELECT email, password FROM developer WHERE email=? " +
                            "UNION " +
                            "SELECT email, password FROM administrator WHERE email=?"
            );
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, email);
            preparedStatement.setString(3, email);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return getByEmailAndPassword(
                        resultSet.getString("email"),
                        resultSet.getString("password")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public User getByEmailAndPassword(String email, String password) throws Exception {
        var customer = customerDAO.getByEmailAndPassword(email, password);
        if (customer != null) return customer;
        var developer = developerDAO.getByEmailAndPassword(email, password);
        if (developer != null) return developer;
        var administrator = administratorDAO.getByEmailAndPassword(email, password);
        if (administrator != null) return administrator;
        return null;
    }

}

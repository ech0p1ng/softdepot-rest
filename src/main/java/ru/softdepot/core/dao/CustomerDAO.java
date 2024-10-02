package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import ru.softdepot.core.models.*;

import java.math.BigDecimal;
import java.sql.*;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;

@Component
@Repository
public class CustomerDAO implements DAO<Customer> {
    private ReviewDAO reviewDAO = new ReviewDAO();
    private ProgramDAO programDAO = new ProgramDAO();
    private PurchaseDAO purchaseDAO = new PurchaseDAO();
    private CartDAO cartDAO = new CartDAO();

    private static Connection connection;

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try {
            connection = DriverManager.getConnection(DataBase.getUrl(), DataBase.getCustomerRole(), DataBase.getCustomerPassword());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int add(Customer customer) throws Exception {
        if (exists(customer.getEmail())) {
            throw new Exception("Customer already exists!");
        }
        try{
            String sql =
                    "INSERT INTO customer (customer_name, email, password, profile_img_url, balance) " +
                    "VALUES(?,?,?,?,?) RETURNING id";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, customer.getName());
            statement.setString(2, customer.getEmail());
            statement.setString(3, customer.getPassword());
            statement.setString(4, customer.getProfileImgUrl());
            statement.setBigDecimal(5, customer.getBalance());

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("id");
            }
        } catch (SQLException e){
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public void update(Customer customer) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "UPDATE customer " +
                            "SET customer_name=?, email=?, password=?, profile_img_url=?, balance=? " +
                            "WHERE id=?"
            );
            statement.setString(1, customer.getName());
            statement.setString(2, customer.getEmail());
            statement.setString(3, customer.getPassword());
            statement.setString(4, customer.getProfileImgUrl());
            statement.setBigDecimal(5, customer.getBalance());
            statement.setInt(6, customer.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(int id) {
        try{
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM customer WHERE id=?"
            );
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Customer getById(int id) throws Exception {
        Customer customer = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM customer WHERE id=?"
            );
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                customer = new Customer(
                        id,
                        resultSet.getString("customer_name"),
                        resultSet.getString("email"),
                        resultSet.getString("password"),
                        resultSet.getString("profile_img_url"),
                        resultSet.getBigDecimal("balance")
                );
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        if (customer == null) {
            String msg = String.format("Customer with id=%d does not exist!", id);
            throw new Exception(msg);
        }

        return customer;
    }

    public boolean exists(String email) {
        boolean exists = false;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM customer WHERE email=?"
            );
            statement.setString(1, email);
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
                    "SELECT * FROM customer WHERE id=?"
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

    public List<Customer> getByName(String name) throws Exception {
        List<Customer> customers = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM customer WHERE customer_name=?"
            );
            statement.setString(1, name);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
//                Customer customer = getById(resultSet.getInt("id"));
                Customer customer = new Customer(
                        resultSet.getInt("id"),
                        resultSet.getString("customer_name"),
                        resultSet.getString("email"),
                        resultSet.getString("password"),
                        resultSet.getString("profile_img_url"),
                        resultSet.getBigDecimal("balance")
                );
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (customers.size() == 0) {
            String msg  = String.format("Customer with [name=%d] does not exist.", name);
            throw new Exception(msg);
        }
        return customers;
    }

    public Customer getByEmailAndPassword(String email, String password) throws Exception {
        Customer customer = null;

        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM customer WHERE email=? AND password=?"
            );
            statement.setString(1, email);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                customer = getById(resultSet.getInt("id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customer;
    }


    public List<Program> getPurchasedPrograms(Customer customer) throws Exception {
        List<Purchase> purchases = purchaseDAO.getPurchasesOfCustomer(customer);
        if (purchases.size() == 0)
            throw new Exception("No purchases found for customer [id=" + customer.getId() +"]");

        List<Program> programs = new ArrayList<>();

        for (Purchase purchase : purchases) {
            Program program = programDAO.getById(purchase.getProgramId());
            programs.add(program);
        }
        return programs;
    }

    public Program getPurchasedProgram(Customer customer, int programId) throws Exception {
        Program program = programDAO.getById(programId);

        if (hasPurchasedProgram(customer, program)) {
            return programDAO.getById(programId);
        }
        else {
            String msg = String.format("Customer [id=%d] did not buy the program [id=%d]",
                    customer.getName(), programId);

            throw new Exception(msg);
        }
    }

    public boolean hasPurchasedProgram(Customer customer, Program program) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM purchase WHERE customer_id=? AND program_id=?"
            );
            statement.setInt(1, customer.getId());
            statement.setInt(2, program.getId());
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void buyProgram(int customerId, int programId) throws Exception {
        Program program = programDAO.getById(programId);
        Customer customer = getById(customerId);

        //если на балансе хватает денег для приобретения программы
        if (customer.getBalance().compareTo(program.getPrice()) > 0 ||
            customer.getBalance().compareTo(program.getPrice()) == 0) {

            Purchase purchase = new Purchase();
            purchase.setCustomerId(customerId);
            purchase.setProgramId(programId);
            purchase.setDateTime(OffsetDateTime.now(ZoneOffset.UTC));

            purchaseDAO.add(purchase);

            //снятие с баланса покупателя суммы
            subtractMoney(customer, program.getPrice());
        }
        else {
            String msg = String.format("Customer [id=%d, balance=%s] does not have enough money " +
                    "to buy program [id=%d, price=%s]", customerId, customer.getBalance(), programId, program.getPrice());
            throw new Exception(msg);
        }
    }

    public void deletePurchasedProgram(Customer customer, Program program) throws Exception {
        Purchase purchase = purchaseDAO.getByCustomerAndProgram(customer, program);
        if (purchase != null) {
            purchaseDAO.delete(purchase.getId());
        }
        else {
            String msg = String.format("Program \"%s\" [id=%d] does not exist in library of customer[id=%d]",
                    program.getName(), program.getId(), customer.getId());
            throw new Exception(msg);
        }
    }


    public int addReview(Review review) throws Exception {
        Customer customer = getById(review.getCustomerId());
        Program program = programDAO.getById(review.getProgramId());

        if (hasPurchasedProgram(customer, program)) {
            return reviewDAO.add(review);
        }
        else {
            String msg = String.format("Customer \"%s\" [id=%d] does not have a program \"%s\" [id=%d]",
                    customer.getName(), customer.getId(), program.getName(), program.getId());

            throw new Exception(msg);
        }
    }

    public void deleteReview(Customer customer, Review review) throws Exception {

        if (review.getCustomerId() != customer.getId()) {
            String msg =
                    String.format("Customer [id=%d] can not delete review " +
                                    "[id=%d] of another customer [id=%d]",
                    customer, review, review.getCustomerId());
            throw new Exception(msg);
        }
        else {
            reviewDAO.delete(review.getId());
        }
    }

    public void deleteReview(Customer customer, Program program) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM review WHERE customer_id=? AND program_id=?"
            );
            statement.setInt(1, customer.getId());
            statement.setInt(2, program.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateReview(Customer customer, Review review) throws Exception {
        if (review.getCustomerId() != customer.getId()) {
            String msg = String.format("Customer [id=%d] can not update review [id=%d] of another customer [id=%d]",
                    customer.getId(), review.getId(), review.getCustomerId());
            throw new Exception(msg);
        }
        reviewDAO.update(review);
    }

    public Review getReview(Customer customer, Program program) throws Exception {
        return reviewDAO.get(customer, program);
    }

    public List<Review> getAllReviewsByCustomer(Customer customer) {
        return reviewDAO.getAllByCustomer(customer);
    }


    public void addMoney(Customer customer, BigDecimal money) throws Exception {
        if (money.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal newMoney = customer.getBalance().add(money);
            customer.setBalance(newMoney);
            update(customer);
        }
        else {
            String msg = String.format("Money amount can not be less than zero (it is %s)", money);
            throw new Exception(msg);
        }
    }

    public void subtractMoney(Customer customer, BigDecimal money) throws Exception {
        if (customer.getBalance().compareTo(money) > 0) {
            customer.setBalance(customer.getBalance().subtract(money));
            update(customer);
        }
        else {
            String msg = String.format("Money amount [%s] can not be greater than balance of customer [balance=%s]",
                    money, customer.getBalance());
            throw new Exception(msg);
        }
    }


    public List<Program> getProgramsInCart(Customer customer) {
        return cartDAO.getPrograms(customer.getId());
    }

    public void addProgram(Customer customer, Program program) {
        cartDAO.addProgram(customer.getId(), program.getId());
    }

    public void deleteProgram(Customer customer, Program program) {
        cartDAO.deleteProgram(customer.getId(), program.getId());
    }
}

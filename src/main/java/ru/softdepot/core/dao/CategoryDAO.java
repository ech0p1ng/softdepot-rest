package ru.softdepot.core.dao;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import ru.softdepot.core.models.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component
@Repository
public class CategoryDAO implements DAO<Category>{
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
    public int add(Category category) throws Exception {
        if (!exists(category.getName())) {
            try {
                PreparedStatement statement = connection.prepareStatement(
                        "INSERT INTO tag (tag_name) VALUES (?)" +
                                "RETURNING id"
                );
                statement.setString(1, category.getName());
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    return resultSet.getInt("id");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        else {
            String msg = String.format("Tag [name=%s] already exists", category.getName());

            throw new Exception(msg);
        }
        return -1;
    }

    @Override
    public void update(Category category) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "UPDATE tag SET tag_name=? WHERE id=?"
            );
            statement.setString(1, category.getName());
            statement.setInt(2, category.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM tag WHERE id=?"
            );
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    @Override
    public Category getById(int id) {
        Category category = null;
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM tag WHERE id=?"
            );
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                category = new Category(id, resultSet.getString("tag_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return category;
    }

    public Category getByName(String name) {
        Category category = null;
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM tag WHERE tag_name=?"
            );
            statement.setString(1, name);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                category = getById(resultSet.getInt("id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return category;
    }

    public List<Category> getAll() {
        List<Category> categories = new ArrayList<Category>();

        try {
            PreparedStatement statement = connection.prepareStatement(
                "SELECT * FROM tag ORDER BY id"
            );
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(new Category(resultSet.getInt("id"), resultSet.getString("tag_name")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    public boolean exists(String tagName) {
        boolean exists = false;
        try {
            PreparedStatement statement = connection.prepareStatement(
                    "SELECT * FROM tag WHERE tag_name=?"
            );
            statement.setString(1, tagName);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                exists = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exists;
    }

    public boolean exists(int tagId){
        Category category = getById(tagId);
        return category != null;
    }
}

package ru.softdepot.core.models;

public class User {
    public enum Type {Customer, Developer, Administrator}
    private int id;

    private String email;

    private String name;

    private String password;

    private Type userType;

    public User(int id, String email, String password, String name, Type userType) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.userType = userType;
        this.id = id;
    }

    public User(String name, String email, String password, Type userType) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.userType = userType;
    }

    public User() {
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
       this.password = password;
    }

    public Type getUserType() {
        return userType;
    }

    public void setUserType(Type userType) {
        this.userType = userType;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getId() {
        return id;
    }
}

package ru.softdepot.core.models;

import jakarta.validation.constraints.NotBlank;
import org.hibernate.validator.constraints.Length;


public class User {
    public enum Type {
        Customer,
        Developer,
        Administrator
        }

    public static final String profileImgPlaceholderUrl ="/styles/images/profile-white.png";

    private int id;

    //    @Email(message = "Некорректный email")
    //    @NotBlank(message = "Введите email")
    private String email;

    @NotBlank(message = "Введите имя")
    @Length(min = 5, max = 30, message = "Имя должно быть длиной от 5 до 30 символов")
    private String name;

    @NotBlank(message = "Введите пароль")
    @Length(min = 8, max = 30, message = "Пароль должен быть длиной от 8 до 30 символов")
    private String password;

    private String pageUrl;

    private Type userType;


    public User(int id, String email, String password, String name, Type userType) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.userType = userType;
        this.id = id;
        this.pageUrl = getPageUrl();
    }

    public User(String name, String email, String password, Type userType) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.userType = userType;
        this.pageUrl = getPageUrl();
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

    public String getPageUrl() {
        return "/" + userType.name().toLowerCase() + "s/" + id;
    }
}

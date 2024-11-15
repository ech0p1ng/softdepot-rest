package ru.softdepot.core.models;

import java.math.BigDecimal;

public class Customer extends User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String profileImgUrl;
    private BigDecimal balance;
    private Type type = Type.Customer;
    private String pageUrl;

    public Customer(int id, String name, String email, String password, String profileImgUrl, BigDecimal balance) {
        super(id, email, password, name, Type.Customer);
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        setProfileImgUrl(profileImgUrl);
        this.pageUrl = super.getPageUrl();
        setBalance(balance);
        this.type = Type.Customer;
    }

    public Customer(User user) {
        super(user.getId(), user.getEmail(), user.getPassword(), user.getName(), user.getUserType());
        this.id = user.getId();
        this.name = user.getName();
        this.email = user.getEmail();
        this.password = user.getPassword();
        this.type = user.getUserType();
        setProfileImgUrl(null);
        this.balance = new BigDecimal(0);
        this.pageUrl = super.getPageUrl();
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public String getProfileImgUrl() {
        if (profileImgUrl == null) {
            return User.profileImgPlaceholderUrl;
        }
        return profileImgUrl;
    }

    public void setProfileImgUrl(String profileImgUrl) {
        this.profileImgUrl = profileImgUrl;
    }

    public Type getType() {
        return type;
    }
}

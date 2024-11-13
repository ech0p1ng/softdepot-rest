package ru.softdepot.core.models;

public class Administrator extends User {
    private int id;
    private String email;
    private String password;
    private String name;
    private Type userType = Type.Administrator;
    private String pageUrl;

    public Administrator(int id, String email, String password, String name) {
        super(id, email, password, name, Type.Administrator);
        this.id = id;
        this.email = email;
        this.password = password;
        this.name = name;
        this.userType = Type.Administrator;
        this.pageUrl = super.getPageUrl();
    }

    public Administrator(User user){
        super(user.getId(), user.getEmail(), user.getPassword(), user.getName(), user.getUserType());
        this.id = user.getId();
        this.email = user.getEmail();
        this.password = user.getPassword();
        this.name = user.getName();
        this.userType = user.getUserType();
        this.pageUrl = super.getPageUrl();
    }

    public Administrator() {
        super();
    }

    @Override
    public int getId() {
        return id;
    }

    @Override
    public String getEmail() {
        return email;
    }

    @Override
    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public Type getUserType() {
        return userType;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }
}

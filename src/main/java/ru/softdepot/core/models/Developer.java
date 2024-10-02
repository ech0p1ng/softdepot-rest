package ru.softdepot.core.models;

public class Developer extends User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String profileImgUrl;
    private Type type = Type.Developer;

    public Developer(int id, String name, String email, String password, String profile_img_url) {
        super(id, email, password, name, Type.Developer);
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.profileImgUrl = profile_img_url;
    }

    public Developer(User user) {
        super(user.getId(), user.getEmail(), user.getPassword(), user.getName(), user.getUserType());
        this.id = user.getId();
        this.name = user.getName();
        this.email = user.getEmail();
        this.password = user.getPassword();
        this.type = user.getUserType();
        this.profileImgUrl = "";
    }

    public Developer() {}

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

    public String getProfileImgUrl() {
        return profileImgUrl;
    }

    public void setProfileImgUrl(String profileImgUrl) {
        this.profileImgUrl = profileImgUrl;
    }

    public Type getType() {
        return type;
    }
}

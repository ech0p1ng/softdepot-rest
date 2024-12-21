package ru.softdepot.core.models;

public class Developer extends User {
    private int id;
    private String name;
    private String password;
    private String profileImgUrl;
    private Type type = Type.Developer;
    private String pageUrl;

    public Developer(int id, String name, String password, String profileImgUrl) {
        super(id, password, name, Type.Developer);
        this.id = id;
        this.name = name;
        this.password = password;
        setProfileImgUrl(profileImgUrl);
        this.pageUrl = super.getPageUrl();
    }

    public Developer(User user) {
        super(user.getId(), user.getPassword(), user.getName(), user.getUserType());
        this.id = user.getId();
        this.name = user.getName();
        this.password = user.getPassword();
        this.type = user.getUserType();
        setProfileImgUrl(null);
        this.pageUrl = super.getPageUrl();
    }

    public Developer() {
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * @param returnPlaceholder если у пользователя нет собственного аватара, то возвращается адрес плейсхолдера
     * @return
     */
    public String getProfileImgUrl(boolean returnPlaceholder) {
        if (this.profileImgUrl == User.profileImgPlaceholderUrl && !returnPlaceholder) {
            return null;
        } else {
            return this.profileImgUrl;
        }
    }

    public void setProfileImgUrl(String profileImgUrl) {
        if (profileImgUrl == null) {
            this.profileImgUrl = User.profileImgPlaceholderUrl;
        } else {
            this.profileImgUrl = profileImgUrl;
        }
    }

    public Type getType() {
        return type;
    }
}

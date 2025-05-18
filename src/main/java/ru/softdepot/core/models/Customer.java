package ru.softdepot.core.models;

import java.math.BigDecimal;
import java.util.List;

public class Customer extends User {
    private int id;
    private String name;
    private String password;
    private String profileImgUrl;
//    private BigDecimal balance;
    private Type type = Type.Customer;
    private String pageUrl;

    public Customer(int id, String name, String password, String profileImgUrl) {
        super(id, password, name, Type.Customer);
        this.id = id;
        this.name = name;
        this.password = password;
        setProfileImgUrl(profileImgUrl);
        this.pageUrl = super.getPageUrl();
//        setBalance(balance);
        this.type = Type.Customer;
    }

    public Customer(User user) {
        super(user.getId(), user.getPassword(), user.getName(), user.getUserType());
        this.id = user.getId();
        this.name = user.getName();
        this.password = user.getPassword();
        this.type = user.getUserType();
        setProfileImgUrl(null);
//        this.balance = new BigDecimal(0);
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

//    public BigDecimal getBalance() {
//        return balance;
//    }
//
//    public void setBalance(BigDecimal balance) {
//        this.balance = balance;
//    }

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

    public String getProfileImgUrl() {
        return profileImgUrl;
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

    public String toString(List<Program> purchasedPrograms) {
        StringBuilder purchasedProgramsSb = new StringBuilder();
        boolean isFirst = true;

        if (purchasedPrograms != null) {
            if (!purchasedPrograms.isEmpty()) {
                for (var p : purchasedPrograms) {
                    if (isFirst) {
                        purchasedProgramsSb.append(p.toString());
                    } else {
                        purchasedProgramsSb.append(", ").append(p.toString());
                    }
                    isFirst = false;
                }
                return "Customer [id=" + id + ", name=" + name + ", purchasedPrograms = ["+purchasedPrograms+"]]";
            }
        }

        return "Customer [id=" + id + ", name=" + name + "]";
    }
}

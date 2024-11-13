let USER = null;

class User {
    constructor(response) {
        this.id = response.id;
        this.email = response.email;
        this.name = response.name;
        this.password = response.password;
        this.userType = response.userType;
        this.profileImgUrl = response.profileImgUrl;
        this.balance = response.balance;
        this.type = response.type;
        this.pageUrl = response.pageUrl;
    }

    static loadUserData () {
        $("#user-profile-button").attr("href", "/sign-in")

        /*Загрузка данных о пользователе*/
        $.ajax({
            method: "GET",
            url: "http://127.0.0.1:8080/softdepot-api/users/current",
            dataType: "json",
            success: function (response) {
                USER = new User(response);
                /*Ссылка на профиль*/
                $("#user-profile-button").attr("href", USER.pageUrl);
            },
            error: function (xhr, status, error) {
                console.error("Ошибка загрузки данных пользователя: ", error);
            }
        });
    }
}

window.addEventListener("load", User.loadUserData);


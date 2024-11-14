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

    static loadUserData() {
        $("#user-profile-button").attr("href", "/sign-in")

        /*Загрузка данных о пользователе*/
        $.ajax({
            method: "GET",
            url: BACKEND_URL + "softdepot-api/users/current",
            dataType: "json",
            success: function (response) {
                USER = new User(response);

                $("#user-profile-button")
                    .attr("href", USER.pageUrl)
                    .attr("title", "Профиль")
                    .addClass("profile")
                    .removeClass("login");


                if (USER.userType === "Customer") {
                    let cartButton = $('<button class="shopping-basket button" title="Корзина" onclick="Cart.show()"></button>');
                    $(".right-buttons-panel").children().eq(0).after(cartButton);
                }
            },
            error: function (xhr, status, error) {
                console.error("Ошибка загрузки данных пользователя: ", xhr.responseJSON.message);
            }
        });
    }
}

window.addEventListener("load", User.loadUserData);


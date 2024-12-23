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
        /*Загрузка данных о пользователе*/
        $.ajax({
            method: "GET",
            url: BACKEND_URL + "softdepot-api/users/current",
            dataType: "json",
            success: function (response) {
                USER = new User(response);

                if (USER.userType === "Customer") {
                    let cartButton = $('<button class="shopping-basket button" title="Корзина" onclick="Cart.show()"></button>');
                    $(".right-buttons-panel").children().eq(0).after(cartButton);
                }

                $("#user-profile-button")
                    .removeClass("login")
                    .addClass("profile")
                    .attr("href", USER.pageUrl);

                $(window).trigger('userDataLoaded');
            },
            error: function (xhr, status, error) {
                console.error("Ошибка загрузки данных пользователя: ", xhr.responseJSON.message);
            }
        });
    }

    setPage() {
        $("#page-title").html("Soft Depot - " + this.name);
        $(".avatar").attr("src", this.profileImgUrl);
        $(".user-name").html(this.name);

        if (USER != null) {
            if (this.userType === USER.userType && this.id === USER.id) {
                $("#user-profile-button")
                    .removeClass("profile")
                    .addClass("logout")
                    .attr("href", "/")
                    .on("click", function () {
                        $.ajax({
                            method: "POST",
                            url: BACKEND_URL + "softdepot-api/users/sign-out",
                            dataType: "json",
                            credentials: "include",
                            success: function (response) {
                                USER = null;
                            },
                            error: function(xhr,status,error) {
                                console.error("Не удалось выйти");
                            }
                        });
                    });
            }
        }
        else {
            $("#user-profile-button").attr("href", "/sign-in");
        }

        var roleStr = "USER_ROLE";

        switch (this.userType) {
            case "Administrator": {
                roleStr = "Администратор";
                $(".user-role").html(roleStr);
                break;
            }
            case "Developer": {
                roleStr = "Разработчик";
                $(".user-role").html(roleStr);

                $.ajax({
                    method: "GET",
                    url: BACKEND_URL + "softdepot-api/products?developerId=" + this.id,
                    dataType: "json",
                    success: function (response) {
                        $("main").append('' +
                            '<h1 id="programs-header">Все программы</h1>' +
                            '<div id="programs-list"></div>'
                        );
                        Program.catalogue.length = 0;
                        response.forEach((element) => {
                            var program = new Program(element);
                            Program.catalogue.push(program);
                            $("#programs-list").append(program.getGameRowPreview());
                        });
                    },
                    error: function(xhr,status,error) {
                        console.error("Не удалось выйти");
                    }
                });
                break;
            }

            case "Customer": {
                roleStr = "Покупатель";
                $(".user-role").html(roleStr);

                $("main").append('' +
                    '<h1 id="programs-header">Библиотека</h1>' +
                    '<div id="programs-list"></div>' +
                    '<h1 id="programs-header">Отзывы пользователя</h1>' +
                    '<div id="reviews-list"></div>'
                );

                $.ajax({
                    method: "GET",
                    url: BACKEND_URL + "softdepot-api/purchases?customerId=" + this.id,
                    dataType: "json",
                    success: function (response) {
                        Program.catalogue.length = 0;
                        response.forEach((element) => {
                            var program = new Program(element);
                            Program.catalogue.push(program);
                            $("#programs-list").append(program.getGameRowPreview());
                        });
                    },
                    error: function(xhr,status,error) {
                    }
                });

                $.ajax({
                    method: "GET",
                    url: BACKEND_URL + "softdepot-api/reviews?customerId=" + this.id,
                    dataType: "json",
                    success: function (response) {

                        response.forEach((element) => {
                            var review = new Review(element);
                            $("#reviews-list").append(review.reviewRowAtUserPage);
                        });
                    },
                    error: function(xhr,status,error) {
                        console.error("Не удалось выйти");
                    }
                });

                break;
            }
        }
    }
}

window.addEventListener("load", function () {
    User.loadUserData();
});
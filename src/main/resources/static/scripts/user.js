class User {
    static dataLoaded = false;

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
        this.hasPurchasedPrograms = false;
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
                    $.ajax({
                        method: "GET",
                        url: BACKEND_URL + "softdepot-api/purchases?customerId=" + USER.id,
                        dataType: "json",
                        success: function (response) {
                            if (response.length > 0) {
                                USER.hasPurchasedPrograms = true;
                                $(window).trigger('userPurchasesLoaded');
                            }
                        },
                        error: function (xhr, status, error) {
                        },
                        complete: () => {
                            User.dataLoaded = true;
                            $(window).trigger('userDataLoaded');
                        }
                    });
                }
                else {
                    User.dataLoaded = true;
                    $(window).trigger('userDataLoaded');
                }
            },
            error: function (xhr, status, error) {
                console.error("Ошибка загрузки данных пользователя: ", xhr.responseJSON.message);
                User.dataLoaded = true;
                $(window).trigger('userDataLoaded');
            },
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
                    .attr("title", "Выйти")
                    .on("click", function (e) {
                        e.preventDefault();
                        $.ajax({
                            method: "POST",
                            url: BACKEND_URL + "softdepot-api/users/sign-out",
                            // dataType: "json",
                            credentials: "include",
                            success: function (response) {
                                USER = null;
                                window.location.href = '/';
                            },
                            error: function (xhr, status, error) {
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

                function getCategoriesItems({ onSuccess, onError, onComplete }) {
                    $.ajax({
                        method: "GET",
                        url: BACKEND_URL + "softdepot-api/categories",
                        dataType: "json",
                        success: (response) => { onSuccess(response) },
                        error: (xhr, status, error) => onError(xhr, status, error),
                        complete: () => onComplete()
                    });
                }

                roleStr = "Администратор";
                $(".user-role").html(roleStr);
                if (USER !== null) {
                    if (this.id === USER.id && this.userType === USER.userType) {

                        getCategoriesItems({
                            onSuccess: (response) => {
                                $("main").append(/*html*/`
                                    <h1 id="categories-header">Категории</h1>
                                    <div id="categories-list"></div>
                                `);

                                response.forEach((element) => {
                                    Tag.emptyCategoryEditor;
                                    var category = new Tag(element);
                                    $("#categories-list").append(category.editorItem);
                                });
                            },
                            onError: (xhr, status, error) => {
                                console.error("Не удалось загрузить категории");
                            },
                            onComplete: () => {
                                let addCategoryButton = $(/*html*/`
                                    <button class="button add-new-category-button">Добавить категорию</button>
                                `);

                                addCategoryButton.on('click', () => {
                                    let item = Tag.getEmptyEditorItem((editorItem) => {
                                        $("#categories-list").append(editorItem);
                                    });
                                    $("#categories-list").append(item);
                                });

                                $("main").append(addCategoryButton);
                            }
                        });

                    }
                }

                break;
            }

            case "Developer": {
                roleStr = "Разработчик";
                $(".user-role").html(roleStr);

                if (USER !== null) {
                    if (this.id === USER.id && this.userType === USER.userType) {
                        let uploadProgramButton = $(/*html*/`
                            <button class="button" id="add-program-as-developer">Добавить программу</button>
                        `);
                        uploadProgramButton.on('click', ProgramUploader.show);
                        $('main').append(uploadProgramButton);
                    }
                }

                $.ajax({
                    method: "GET",
                    url: BACKEND_URL + "softdepot-api/products?developerId=" + this.id,
                    dataType: "json",
                    success: (response) => {
                        if (response.length > 0) {
                            $("main").append(/*html*/`
                                <h1 id="programs-header">Программы от ${this.name}</h1>
                                <div id="programs-list"></div>
                            `);
                        }
                        Program.catalogue.length = 0;

                        response.forEach((element) => {
                            var program = new Program(element);
                            Program.catalogue.push(program);
                            $("#programs-list").append(program.getGameRowPreview());
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Не удалось выйти");
                    }
                });
                break;
            }

            case "Customer": {
                roleStr = "Покупатель";
                $(".user-role").html(roleStr);

                let libItem = $(/*html*/`
                    <h1 id="programs-header">Библиотека</h1>
                    <div id="programs-list"></div>
                `);

                let reviewsItem = $(/*html*/`
                    <h1 id="programs-header">Отзывы пользователя</h1>
                    <div id="reviews-list"></div>
                `);

                $("main").append(libItem);

                $("main").append(reviewsItem);

                $.ajax({
                    method: "GET",
                    url: BACKEND_URL + "softdepot-api/purchases?customerId=" + this.id,
                    dataType: "json",
                    success: function (response) {
                        Program.catalogue.length = 0;
                        if (response.length == 0) {
                            libItem.remove();
                        }
                        else {
                            response.forEach((element) => {
                                var program = new Program(element);
                                Program.catalogue.push(program);
                                $("#programs-list").append(program.getGameRowPreview());
                            });
                        }
                    },
                    error: function (xhr, status, error) {
                    }
                });

                $.ajax({
                    method: "GET",
                    url: BACKEND_URL + "softdepot-api/reviews?customerId=" + this.id,
                    dataType: "json",
                    success: function (response) {
                        if (response.length == 0) {
                            reviewsItem.remove();
                        }
                        else {
                            response.forEach((element) => {
                                var review = new Review(element);
                                $("#reviews-list").append(review.getReviewRowAtUserPage());
                            });
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("Не удалось выйти");
                    }
                });

                break;
            }
        }
    }
}


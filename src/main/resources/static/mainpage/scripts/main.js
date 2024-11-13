window.addEventListener("load", function () {
    $.ajax({
        method: "GET",
        url: "http://127.0.0.1:8080/softdepot-api/products",
        dataType: "json",
        success: function (data) {
            data.forEach((element) => {
                let game = new Game(element);
                $("#games-list").append(game.getGameRowPreview());
            });
        },
    });

    $("#user-profile-button").attr("href", "/sign-in")

    $.ajax({
        method: "GET",
        url: "http://127.0.0.1:8080/softdepot-api/users/current",
        dataType: "json",
        success: function (response) {
            console.log(response);
            let user = new User()
        },
        error: function (xhr, status, error) {
            console.error(error);
        }
    });
});

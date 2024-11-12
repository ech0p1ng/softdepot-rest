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

    let token = getAuthToken();
    if (token == null) {
        $("#user-profile-button").attr("href", "/sign-in")
    } else {
        $.ajax({
            method: "GET",
            url: "http://127.0.0.1:8080/softdepot-api/users?" + token,
            dataType: "json",
            success: function (response) {
                console.log(response);
            },
            error: function (xhr, status, error) {

            }
        });
    }
});

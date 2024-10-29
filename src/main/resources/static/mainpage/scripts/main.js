window.onload = () => {
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
};

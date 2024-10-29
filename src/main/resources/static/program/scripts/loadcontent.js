$(document).ready(function () {
    // Получаем ID программы из URL
    var url = window.location.href;
    var id = url.substring(url.lastIndexOf("/") + 1);

    $.ajax({
        method: "GET",
        url: "http://127.0.0.1:8080/softdepot-api/products/" + id,
        // contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (data) {
            let game = new Game(data);
            game.setProgramPage();
        },
    });
});

$(document).ready(function () {
    // Получаем ID программы из URL
    var url = window.location.href;
    var id = url.substring(url.lastIndexOf("/") + 1);

    $.ajax({
        method: "GET",
        url: BACKEND_URL + "softdepot-api/products/" + id,
        // contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (data) {
            let game = new Program(data);
            game.setProgramPage();
        },
        error: function (error) {
            window.location.href="/";
        }
    });
});

function change_current_screenshot() {
    $("#current-screenshot").attr("src", this.src);
}

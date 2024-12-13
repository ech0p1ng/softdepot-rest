window.addEventListener("load", function () {
    // Получаем ID разработчика из URL
    var url = window.location.href;
    var id = url.substring(url.lastIndexOf("/") + 1);

    var developer;
    addHeader(true, true);

    $.ajax({
        method: "GET",
        url: BACKEND_URL + "softdepot-api/developers/" + id,
        dataType: "json",
        success: function (response) {
            developer = new User(response);
            developer.setPage();
        },
        error: function (xhr, status, error) {
            console.error("Ошибка загрузки данных пользователя: ", xhr.responseJSON.message);
        }
    });

});
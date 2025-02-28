let userDataLoaded = false;

$(window).on('userDataLoaded', function () { userDataLoaded = true; })

window.addEventListener("load", function () {
    var url = window.location.href;

    var urlParts = url.split("/");
    var type = urlParts[3];
    var id = urlParts[4];

    var userOfPage;
    addHeader(true, true);

    $.ajax({
        method: "GET",
        url: BACKEND_URL + "softdepot-api/" + type + "/" + id,
        dataType: "json",
        success: function (response) {
            userOfPage = new User(response);

            if (userDataLoaded) {
                userOfPage.setPage();
            }
            else {
                $(window).on('userDataLoaded', () => userOfPage.setPage());
            }
        },
        error: function (xhr, status, error) {
            console.error("Ошибка загрузки данных пользователя: ", xhr.responseJSON.message);
        }
    });

});
window.addEventListener("load", function () {
    // Получаем ID программы из URL
    var url = window.location.href;
    var id = url.substring(url.lastIndexOf("/") + 1);


    addHeader(true, true);

    $.ajax({
        method: "GET",
        url: BACKEND_URL + "softdepot-api/products/" + id,
        dataType: "json",
        success: function (response) {
            let program = new Program(response);
            program.setProgramPage();
            Program.catalogue.push(program);
        },
        error: function (error) {
            window.location.href="/";
        }
    });
});

function change_current_screenshot() {
    $("#current-screenshot").attr("src", this.src);
}

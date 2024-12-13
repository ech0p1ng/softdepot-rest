window.addEventListener("load", function () {
    addHeader(true, true);

    $.ajax({
        method: "GET",
        url: BACKEND_URL + "softdepot-api/products",
        dataType: "json",
        success: function (data) {
            data.forEach((element) => {
                let program = new Program(element);
                Program.catalogue.push(program);
                $("#games-list").append(program.getGameRowPreview());
            });
        },
    });
});


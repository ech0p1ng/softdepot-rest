$(window).on("userDataLoaded", () => {
    addHeader(true, true);
    $.ajax({
        method: "GET",
        url: BACKEND_URL + "softdepot-api/products/recommendations?customerId=" + USER.id,
        dataType: "json",
        success: function (data) {
            data.forEach((element) => {
                let program = new Program(element);
                Program.catalogue.push(program);
                $("#games-list").append(program.getGameRowPreview());
            });
        },
        error: function (xhr, status, error) {
            alert(JSON.stringify(xhr.responseJSON));
        }
    });
});
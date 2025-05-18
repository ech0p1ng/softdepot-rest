$(window).on("userDataLoaded", () => {
    addHeader(true, true);
    $.ajax({
        method: "GET",
        url: BACKEND_URL + "softdepot-api/products/recommendations?customerId=" + USER.id,
        dataType: "json",
        success: function (data) {
            let elements_count = 0;
            data.forEach((element) => {
                let program = new Program(element);
                Program.catalogue.push(program);
                $("#games-list").append(program.getGameRowPreview());
                elements_count += 1;
            });

            if (elements_count === 0) {
                $('#programs-header').html('Рекомендаций пока для вас нет😞')
                $('#games-list').append(
                    $(/*html*/`
                    <span>Рекомендации работают только если вы купили хоть что-нибудь или если не скупили все🤭</span>    
                    `)
                )
            }
        },
        error: function (xhr, status, error) {
            alert(xhr.responseJSON.message);
        }
    });
});
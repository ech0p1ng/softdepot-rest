window.onload = () => {
    let games_list_elem = document.getElementById("games-list");

    $.ajax({
        method: "GET",
        url: "http://127.0.0.1:8080/softdepot-api/products",
        // contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (data) {
            data.forEach((element) => {
                let game = new Game(element.name, element.headerUrl, element.id, element.price, "", element.averageEstimation, element.shortDescription, element.fullDescription);
                games_list_elem.append(game.getGameRowPreview());
            });
        },
    });

    // games_list.forEach((game) => {
    //     games_list_elem.append(game.getGameRowPreview());
    // });
};

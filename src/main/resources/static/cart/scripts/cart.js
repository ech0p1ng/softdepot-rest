function show_cart() {
    $("#cart-games-list").empty();

    $.ajax({
       method: "GET",
        url: "http://127.0.0.1:8080/softdepot-api/carts/" + USER.id,
        dataType: "json",
        success: function (cartOfGames) {
            cartOfGames.forEach((game) => {
                let game_row = game.getCartGameRow();
                $("#cart-games-list").append(game_row);
            });

            //Подсчет суммы в корзине
            let sum = 0;
            cartOfGames.forEach((game) => {
                sum += game.price;
            });
            $("#total-cost").html(sum + " руб.");

            $("#cart-bg").css("visibility", "inherit");
        },
        error: function (xhr, status, error) {
            alert("Не удалось загрузить корзину");
            console.error(error);
        }
    });


}

function close_cart() {
    $("#cart-bg").css("visibility", "hidden");
}

$("#cart-exit-button").on("click", close_cart);

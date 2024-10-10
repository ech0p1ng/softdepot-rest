let cart_of_games = [];

function count_sum() {
    let sum = 0;
    cart_of_games.forEach((game) => {
        sum += game.price;
    });
    $("#total-cost").html(sum + " руб.");
}

function show_cart() {
    $("#cart-games-list").empty();
    cart_of_games.forEach((game) => {
        let game_row = game.get_cart_game_row();
        $("#cart-games-list").append(game_row);
    });

    count_sum();
    $("#cart-bg").css("visibility", "inherit");
}

function close_cart() {
    $("#cart-bg").css("visibility", "hidden");
}

$("#cart-exit-button").on("click", close_cart);

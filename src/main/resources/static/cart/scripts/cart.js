class Cart {
    static show() {
        $("#cart-games-list").empty();
        Cart.update(true);
    }

    static update(showCart) {
        $("#cart-games-list").empty();

        $.ajax({
            method: "GET",
            url: BACKEND_URL + "softdepot-api/carts/" + USER.id,
            dataType: "json",
            success: function (response) {
                let sum = 0;

                $("#cart-games-list").html('');
                response.forEach((responseElem) => {
                    let program = Program.catalogue.find(arrayElem => arrayElem.id === responseElem.id);

                    if (program) program.setProgramPageAddToCartButton();
                    else program = new Program(responseElem);

                    $("#cart-games-list").append(program.getCartGameRow());
                    sum += program.price;
                });

                $("#total-cost").html(sum + " руб.");
                if (showCart)
                    $("#cart-bg").css("visibility", "inherit");
            },
            error: function (xhr, status, error) {
                alert("Не удалось загрузить корзину");
                console.error(error);
            }
        });
    }

    static close() {
        $("#cart-bg").css("visibility", "hidden");
    }
}


$("#cart-exit-button").on("click", Cart.close);

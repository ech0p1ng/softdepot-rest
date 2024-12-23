class Cart {

    static cart = $('' +
        '<!-- Корзина -->' +
        '    <div id="cart-bg">' +
        '        <div id="cart-opened">' +
        '            <div id="cart-header">' +
        '                <span id="cart-title">Корзина</span>' +
        '                <button id="cart-exit-button" class="exit-button button close-button" onclick="Cart.close()"></button>' +
        '            </div>' +
        '            <div id="cart-games-list">' +
        '            </div>' +
        '            <div id="cart-total-title">' +
        '                <span>Итого</span>' +
        '                <span id="total-cost">0 руб.</span>' +
        '            </div>' +
        '        </div>' +
        '    </div>'
    );

    static show() {
        $('main').append(this.cart);
        Cart.update();
    }

    static update() {
        this.cart.find("#cart-games-list").empty();

        $.ajax({
            method: "GET",
            url: BACKEND_URL + "softdepot-api/carts/" + USER.id,
            dataType: "json",
            success: (response) => {
                let sum = 0;

                $("#cart-games-list").html('');
                response.forEach((responseElem) => {
                    let program = Program.catalogue.find(arrayElem => arrayElem.id === responseElem.id);

                    if (program) program.setProgramPageAddToCartButton();
                    else program = new Program(responseElem);

                    $("#cart-games-list").append(program.getCartGameRow());
                    sum += program.price;
                });

                this.cart.find("#total-cost").html(sum + " руб.");
            },
            error: (xhr, status, error) => {
                alert("Не удалось загрузить корзину");
                console.error(error);
            }
        });
    }

    static close() {
        this.cart.remove();
    }
}


$("#cart-exit-button").on("click", () => Cart.cart.remove());

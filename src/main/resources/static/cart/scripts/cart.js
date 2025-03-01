class Cart {

    static cart = $(/*html*/`
        <!-- Корзина -->
            <div id="pop-up-bg">
                <div id="cart-opened">
                    <div id="cart-header">
                        <span id="cart-title">Корзина</span>
                        <button id="cart-exit-button" class="exit-button button close-button" onclick="Cart.close()"></button>
                    </div>
                    <div id="cart-games-list">
                    </div>
                    <div id="cart-total-title">
                        <span>Итого</span>
                        <span id="total-cost">0 руб.</span>
                        <button class="button" id="buy-from-cart">Купить</button>
                    </div>
                </div>
            </div>
    `);

    static show() {
        $('main').append(this.cart);
        Cart.update();
    }

    static programsInCart = [];

    static update() {
        this.cart.find("#cart-games-list").empty();

        $.ajax({
            method: "GET",
            url: BACKEND_URL + "softdepot-api/carts/" + USER.id,
            dataType: "json",
            success: (response) => {
                this.programsInCart = [];
                let sum = 0;

                $("#cart-games-list").html('');
                response.forEach((responseElem) => {
                    let program = Program.catalogue.find(arrayElem => arrayElem.id === responseElem.id);

                    if (program) program.setProgramPageAddToCartButton();
                    else program = new Program(responseElem);

                    this.programsInCart.push(program);

                    $("#cart-games-list").append(program.getCartGameRow());
                    sum += program.price;
                });

                if (this.programsInCart.length === 0) {
                    this.cart.find('#buy-from-cart').prop('disabled', true);
                }
                else {
                    this.cart.find('#buy-from-cart').prop('disabled', false);
                }

                this.cart.find("#total-cost").html(sum + " руб.");

                this.cart.find('#buy-from-cart').on('click', () => {
                    const confirmed = confirm("Вы действительно хотите купить все программы из корзины?")
                    if (confirmed) {
                        this.programsInCart.forEach(programInCart => {

                            const data = {
                                "customerId": USER.id,
                                "programId": programInCart.id
                            }

                            $.ajax({
                                method: "POST",
                                url: BACKEND_URL + "softdepot-api/purchases/new",
                                contentType: 'application/json',
                                data: JSON.stringify(data),
                                success: (response) => {
                                    Cart.update();
                                    programInCart.isPurchased = true;
                                    programInCart.isInCart = false;
                                    programInCart.setCatalogueRowButton();
                                    $(`#main-page-game-row-${programInCart.id}`)
                                        .replaceWith(programInCart.gameRowCatalogue);
                                },
                                error: function (xhr, status, error) {
                                    alert(`Не удалось приобрести ${programInCart.name}`);
                                }
                            });
                        });

                    }
                });
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

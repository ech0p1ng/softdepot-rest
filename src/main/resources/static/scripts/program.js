const addToCartHtml = '<span>Добавить в корзину</span>';
const removeFromCartHtml = '<span>Удалить из корзины</span>';
const signInToBuyHtml = '<span>Войдите чтобы купить</span>';
const onlyCustomerCanBuyHtml = '<span>Только покупатель может купить</span>';
const removeFromCatalogHtml = '<span>Удалить из каталога</span>';

class Program {
    static catalogue = [];

    constructor(data) {
        this.id = data.id;
        this.name = data.name;
        this.price = data.price;
        this.fullDescription = data.fullDescription;
        this.developerId = data.developerId;
        this.shortDescription = data.shortDescription;
        this.averageEstimation = data.averageEstimation;
        this.nameForPath = data.nameForPath;
        this.winInstaller = data.winInstaller;
        this.linuxInstaller = data.linuxInstaller;
        this.macosInstaller = data.macosInstaller;
        this.headerImg = data.headerImg;
        this.screenshots = data.screenshots;
        this.logo = data.logo;
        this.headerUrl = data.headerUrl;
        this.tags = data.tags;
        this.logoUrl = data.logoUrl;
        this.installerLinuxUrl = data.installerLinuxUrl;
        this.installerMacosUrl = data.installerMacosUrl;
        this.installerWindowsUrl = data.installerWindowsUrl;
        this.tagsAsString = data.tagsAsString;
        this.screenshotsUrls = data.screenshotsUrls;
        this.priceAsString = data.priceAsString;
        this.pageUrl = data.pageUrl;
        this.isInCart = data.isInCart;
        this.hasReview = data.hasReview;
        this.isPurchased = data.isPurchased;


        //Строка в корзине
        this.gameRowCart = $(
            '<div class="cart-game-row">' +
            '    <img class="preview" src="' + this.headerUrl + '" />' +
            '    <a class="cart-game-description" href="' + this.pageUrl + '">' +
            '        <span class="cart-game-title">' + this.name + '</span>' +
            '    </a>' +
            '    <div class="cart-game-price">' +
            '        <span class="cart-game-price-title">' + this.priceAsString + '</span>' +
            '        <button class="cart-game-remove button close-button-bright"></button>' +
            '    </div>' +
            '</div>'
        );

        //Строка в каталоге
        this.gameRowCatalogue = $(/*html*/`
            <div class="game-row" id="main-page-game-row-${this.id}" style="z-index: 1">
               <a href="${this.pageUrl}" class="preview" target="_blank" class="description">
                 <img class="preview" src="${this.headerUrl}" />
               </a>
            	<a href="${this.pageUrl}" target="_blank" class="description">
            		<div>
            			<span class="name">${this.name}</span>
            			<br />
            			<span class="tags">${this.tagsAsString}</span>
            		</div>
                    <span class="score" title="Оценка пользователей" style="color: ${Program.getScoreColor(this.averageEstimation)}">${this.averageEstimation}</span>
            	</a>
                <div class="price-and-buy">
                    <span class="price">
            			<span>${this.priceAsString}</span>
            		</span>
                   <button class="add-to-cart" style="z-index: 2">${addToCartHtml}</button>
                </div>
            </div>
        `);

        this.gameRowCatalogue
            .find('.add-to-cart')
            .html(addToCartHtml)
            .off('click')
            .on('click', () => this.addToCart());

        this.setCatalogueRowButton();
    }


    //Определение цвета оценки по числу (0 - красный, 5 - зеленый)
    static getScoreColor(score) {
        let range = 255 * 2;

        let red = 255;
        let green = 0;
        let blue = 0;

        let redRangeEnd = 2.2;

        if (score > redRangeEnd) {
            let position = (range / (5.0 - redRangeEnd) * (score - redRangeEnd));
            green += position;

            if (green > 255) {
                red -= green - 255 + 1;
                green = 255;
            }
        }

        return "rgb(" + red + "," + green + "," + blue + ")";
    }

    setEventsForCatalogueRowButton() {
        if (this.isInCart) {
            this.gameRowCatalogue
                .find('.remove-from-cart')
                .off('click')
                .on('click', () => {
                    this.removeFromCart();
                });
        } else {
            this.gameRowCatalogue
                .find('.add-to-cart')
                .off('click')
                .on('click', () => {
                    this.addToCart();
                });
        }
    }

    setCatalogueRowButton() {
        if (USER != null) {
            if (USER.type === "Customer") {
                if (this.isPurchased) {
                    this.gameRowCatalogue
                        .find(".price-and-buy")
                        .removeClass("price-and-buy")
                        .addClass("price-no-buy");
                    this.gameRowCatalogue
                        .find('.add-to-cart').remove();
                    this.gameRowCatalogue
                        .find('.remove-from-cart').remove();

                }
                else if (this.isInCart) {
                    this.gameRowCatalogue
                        .find('.add-to-cart')
                        .addClass('remove-from-cart')
                        .removeClass('add-to-cart')
                        .html(removeFromCartHtml)
                        .off('click')
                        .on('click', () => this.removeFromCart());
                }
                else {
                    this.gameRowCatalogue
                        .find('.remove-from-cart')
                        .addClass('add-to-cart')
                        .removeClass('remove-from-cart')
                        .html(addToCartHtml)
                        .off('click')
                        .on('click', () => this.addToCart());

                }
            }

            else if (USER.type === "Developer" && this.developerId === USER.id) {
                this.gameRowCatalogue
                    .find('.add-to-cart')
                    .addClass('remove-from-cart')
                    .removeClass('add-to-cart')
                    .removeClass('cant-buy')
                    .html(removeFromCatalogHtml)
                    .off('click')
                    .on('click', () => {
                        this.removeFromCatalog();
                    });
            }

            else {
                this.gameRowCatalogue
                    .find('.add-to-cart')
                    .addClass('cant-buy')
                    .removeClass('add-to-cart')
                    .html(onlyCustomerCanBuyHtml)
                    .off('click')
                    .on('click', () => window.open('/sign-in'));
            }
        }
        else {
            //Строка в каталоге
            this.gameRowCatalogue
                .find('.add-to-cart')
                .addClass('cant-buy')
                .removeClass('add-to-cart')
                .html(signInToBuyHtml)
                .off('click')
                .on('click', () => window.open('/sign-in'));
        }

        // this.setEventsForCatalogueRowButton();
    }

    setProgramPageAddToCartButton() {
        if (USER != null) {
            if (USER.type === "Customer") {
                if (this.isPurchased) {
                    $("#add-to-cart-from-page").remove();
                }
                if (this.isInCart) {
                    $("#add-to-cart-from-page")
                        .addClass('remove-from-cart')
                        .removeClass('add-to-cart')
                        .html(removeFromCartHtml)
                        .off('click')
                        .on('click', () => {
                            this.removeFromCart();
                        });
                }
                else {
                    $("#add-to-cart-from-page")
                        .addClass('add-to-cart')
                        .removeClass('remove-from-cart')
                        .html(addToCartHtml)
                        .off('click')
                        .on('click', () => {
                            this.addToCart();
                        });
                }
            }
            else if (USER.type === "Developer" && this.developerId === USER.id) {
                $("#add-to-cart-from-page")
                    .addClass('remove-from-cart')
                    .removeClass('add-to-cart')
                    .removeClass('cant-buy')
                    .html(removeFromCatalogHtml)
                    .off('click')
                    .on('click', () => {
                        this.removeFromCatalog();
                    });
            }

            else {
                $("#add-to-cart-from-page")
                    .addClass('cant-buy')
                    .removeClass('remove-from-cart')
                    .removeClass('add-to-cart')
                    .html(onlyCustomerCanBuyHtml)
                    .off('click')
                    .on('click', () => {
                        window.open("/sign-in")
                    });
            }
        }
        else {
            $("#add-to-cart-from-page")
                .addClass('cant-buy')
                .removeClass('remove-from-cart')
                .removeClass('add-to-cart')
                .html(signInToBuyHtml)
                .off('click')
                .on('click', () => {
                    window.open("/sign-in")
                });
        }

    }

    addToCart() {
        this.isInCart = true;
        $.ajax({
            method: "POST",
            url: BACKEND_URL + "softdepot-api/carts/" + USER.id + "?programId=" + this.id,
            contentType: 'application/json',
            data: null,
            success: (response) => {
                this.setCatalogueRowButton();
                this.setProgramPageAddToCartButton();
                // Cart.update(false);
            },
            error: (xhr, status, message) => {
                console.error(xhr.responseJSON.message);
                alert("Не удалось добавить " + this.name + " в корзину.\n" + xhr.responseJSON.message);
            }
        });
    }

    removeFromCart() {
        // cart_of_games.splice(cart_of_games.indexOf(this), 1);
        this.isInCart = false;
        $.ajax({
            method: "DELETE",
            url: BACKEND_URL + "softdepot-api/carts/" + USER.id + "?programId=" + this.id,
            contentType: 'application/json',
            data: null,
            success: (response) => {
                this.setCatalogueRowButton();
                this.setProgramPageAddToCartButton();
                Cart.update(false);
            },
            error: (xhr, status, message) => {
                console.error(xhr.responseJSON.message);
                alert("Не удалось удалить " + this.name + " из корзины");
            }
        });
    }

    removeFromCatalog() {
        const confirmed = confirm(`Вы действительно хотите удалить ${this.name} из каталога?`);
        if (confirmed) {
            $.ajax({
                method: "DELETE",
                url: BACKEND_URL + "softdepot-api/products/" + this.id,
                dataType: false,
                success: (response) => {
                    this.gameRowCatalogue.remove();
                    const index = Program.catalogue.findIndex(item => item.id === this.id);
                    Program.catalogue.splice(index, 1);
                },
                error: (xhr, status, error) => {
                    alert(`Не удалось удалить ${this.name} из каталога`);
                }
            });
        }
    }
    //Создание строки в каталоге
    getGameRowPreview() {
        return this.gameRowCatalogue;
    }

    //Строка в корзине
    getCartGameRow() {
        this.gameRowCart
            .find('.cart-game-remove.button')
            .off('click')
            .on('click', () => {
                this.removeFromCart();
            });
        return this.gameRowCart;

    }

    //Заполнение данных на странице программы
    setProgramPage() {
        $("#page-title").html("Soft Depot - " + this.name);
        $(".header").attr("src", this.headerUrl);
        $("#short-description").html(this.shortDescription);
        $(".game-name").html(this.name);
        $("#score")
            .html(this.averageEstimation)
            .attr("style", "color: " + Program.getScoreColor(this.averageEstimation));
        $("#description-text").html(this.fullDescription);
        $("#price").html(this.priceAsString);

        this.setProgramPageAddToCartButton();

        let first = true;
        this.screenshotsUrls.forEach((img) => {
            let screenshot = $('<img className="screenshot-on-tape" src="' + img + '" onClick="change_current_screenshot.apply(this)"/>');
            if (first) {
                $(".screenshots-viewer").append('<img id="current-screenshot" src="' + img + '" />');
                first = false;
            }
            $(".screenshots-tape").append(screenshot);
        });

        $.ajax({
            method: "GET",
            url: BACKEND_URL + "softdepot-api/reviews?programId=" + this.id,
            type: "json",
            success: (response) => {
                response.forEach(elem => {
                    let review = new Review(elem);
                    $("#reviews-header").css("visibility", "visible");
                    $(".reviews")
                        .css("visibility", "visible")
                        .append(review.getReviewRow());
                })
            },
            error: (xhr, status, error) => {
                console.log(xhr.responseJSON.message);

            }
        });
    }
}
class Program {
    static catalogue = []
    constructor(data) {
        this.id = data.id;
        this.name = data.name;
        this.price = data.price;
        this.fullDescription = data.fullDescription;
        this.developerId = data.developerId;
        this.shortDescription = data.shortDescription;
        this.inCart = data.inCart;
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
        this.screenshotsUrl = data.screenshotsUrl;
        this.priceAsString = data.priceAsString;
        this.pageUrl = data.pageUrl;

        //Строка в каталоге
        this.gameRowCatalogue = $(
            '<div class="game-row" id="main-page-game-row-' + this.id + '" style="z-index: 1">' +
            '  <a href="' + this.pageUrl + '" class="preview" target="_blank" class="description">' +
            '    <img class="preview" src="' + this.headerUrl + '" /></a>' +
            '	<a href="' + this.pageUrl + '" target="_blank" class="description">' +
            '		<div>' +
            '			<span class="name">' + this.name + '</span>' +
            '			<br />' +
            '			<span class="tags">' + this.tagsAsString + '</span>' +
            '		</div>' +
            '        <span class="score" title="Оценка пользователей" style="color: ' + Program.getScoreColor(this.averageEstimation) + '">' + this.averageEstimation + '</span>' +
            '	</a>' +
            '    <div class="price-and-buy">' +
            '        <span class="price">' +
            '			<span>' + this.priceAsString + '</span>' +
            '		</span>' +
            '		<button class="add-to-cart" style="z-index: 2">' +
            '			<span>Добавить в корзину</span>' +
            '		</button>' +
            '    </div>' +
            '</div>'
        );

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

        this.gameRowCart
            .find('.cart-game-remove.button')
            .on('click', () => {
                this.removeFromCart();
            });

        this.setCatalogueRowButton();
    }

    //Определение цвета оценки по числу (0 - красный, 5 - зеленый)
    static getScoreColor(score) {
        let range = 512;
        let r = 255;
        let g = 0;
        let b = 0;
        let g1 = parseInt((range / 5) * parseFloat(score));
        g += g1;

        if (g > 255) {
            r -= g - 255;
            g = 255;
        }
        r -= 64;
        g -= 64;
        b -= 64;

        return "rgb(" + r + "," + g + "," + b + ")";
    }

    setEventsForCatalogueRowButton() {
        if (this.inCart) {
            this.gameRowCatalogue
                .find('.remove-from-cart')
                .off('click')
                .on('click', () => {
                    this.removeFromCart();
                });
        }
        else {
            this.gameRowCatalogue
                .find('.add-to-cart')
                .off('click')
                .on('click', () => {
                    this.addToCart();
                });
        }
    }


    setCatalogueRowButton() {
        if (this.inCart) {
            this.gameRowCatalogue
                //замена стиля кнопки
                .find('.add-to-cart')
                .addClass('remove-from-cart')
                .removeClass('add-to-cart')
                .html('<span>Удалить из корзины</span>')
                // .off('click') //удаляет старые обработчики события
                // .on('click', () => {
                //     this.removeFromCart();
                // });

        }
        else {
            this.gameRowCatalogue
                .find('.remove-from-cart')
                .addClass('add-to-cart')
                .removeClass('remove-from-cart')
                .html('<span>Добавить в корзину</span>')
                // .off('click')
                // .on('click', () => {
                //     this.addToCart();
                // });
        }
        this.setEventsForCatalogueRowButton();
    }

    addToCart() {
        // cart_of_games.push(this);
        this.inCart = true;
        $.ajax({
            method: "POST",
            url: BACKEND_URL + "softdepot-api/carts/" + USER.id + "?programId=" + this.id,
            contentType: 'application/json',
            data: null,
            success: (response) => {
                this.setCatalogueRowButton();
            },
            error: (xhr, status, message) => {
                console.error(xhr.responseJSON.message);
                alert("Не удалось добавить " + this.name + " в корзину.\n" + xhr.responseJSON.message);
            }
        });
        // this._add_to_cart_button.innerHTML = "<span>Удалить из корзины</span>";
        // this._add_to_cart_button.className = "remove-from-cart";
    }

    // удаление из корзины
    removeFromCart() {
        // cart_of_games.splice(cart_of_games.indexOf(this), 1);
        this.inCart = false;
        $.ajax({
            method: "DELETE",
            url: BACKEND_URL + "softdepot-api/carts/" + USER.id + "?programId=" + this.id,
            contentType: 'application/json',
            data: null,
            success: (response) => {
                this.setCatalogueRowButton();
                Cart.update(false);
            },
            error: (xhr, status, message) => {
                console.error(xhr.responseJSON.message);
                alert("Не удалось удалить " + this.name + " из корзины");
            }
        });
        // this._add_to_cart_button.innerHTML = "<span>Добавить в корзину</span>";
        // this._add_to_cart_button.className = "add-to-cart";
    }

    // changeAddToCartButton() {
    //     if (this.in_cart) {
    //         this._add_to_cart_button.innerHTML = "<span>Добавить в корзину</span>";
    //         this._add_to_cart_button.className = "add-to-cart";
    //     } else {
    //         this._add_to_cart_button.innerHTML = "<span>Удалить из корзины</span>";
    //         this._add_to_cart_button.className = "remove-from-cart";
    //     }
    // }

    //Создание строки в каталоге
    getGameRowPreview() {
        return this.gameRowCatalogue;
    }

    //Строка в корзине
    getCartGameRow() {
        // let cart_game_row = document.createElement("div");
        // let cart_game_preview = document.createElement("img");
        // let cart_game_description = document.createElement("a");
        // let cart_game_title = document.createElement("span");
        // let cart_game_price = document.createElement("div");
        // let cart_game_price_title = document.createElement("span");
        // let cart_game_remove = document.createElement("button");
        //
        // cart_game_row.className = "cart-game-row";
        // cart_game_preview.className = "preview";
        // cart_game_description.className = "cart-game-description";
        // cart_game_title.className = "cart-game-title";
        // cart_game_price.className = "cart-game-price";
        // cart_game_price_title.className = "cart-game-price-title";
        // cart_game_remove.className = "cart-game-remove button close-button-bright";
        //
        // cart_game_preview.src = this.headerUrl;
        // cart_game_description.href = this.pageUrl;
        // cart_game_title.innerHTML = this.name;
        // cart_game_price_title.innerHTML = this.price > 0 ? this.price + " руб." : "Бесплатно";
        // cart_game_remove.onclick = () => {
        //     this.removeFromCart();
        //     show_cart();
        // };
        //
        // cart_game_description.append(cart_game_title);
        // cart_game_price.append(cart_game_price_title, cart_game_remove);
        // cart_game_row.append(cart_game_preview, cart_game_description, cart_game_price);
        //
        // return cart_game_row;

        return this.gameRowCart;

    }

    //Заполнение данных на странице программы
    setProgramPage() {
        $("#page-title").html("Soft Depot - " + this.name);
        $(".header").attr("src", this.headerUrl);
        $("#short-description").html(this.shortDescription);
        $(".game-name").html(this.name);
        $("#score").html(this.averageEstimation);
        $("#score").attr("style", "color: " + Program.getScoreColor(this.averageEstimation));
        $("#description-text").html(this.fullDescription);
        $("#price").html(this.priceAsString);
        $(".add-to-cart").attr("program-id", this.id);

        let first = true;
        this.screenshotsUrl.forEach((img) => {
            let screenshot = $('<img className="screenshot-on-tape" src="' + img + '" onClick="change_current_screenshot.apply(this)"/>');
            if (first) {
                $(".screenshots-viewer").append('<img id="current-screenshot" src="' + img + '" />');
                first = false;
            }
            $(".screenshots-tape").append(screenshot);
        });

    }
}
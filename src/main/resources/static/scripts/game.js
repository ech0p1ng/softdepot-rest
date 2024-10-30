class Game {
    // constructor(name, preview_img, url, price, tags, score, description, big_description) {
    //     this.name = name;
    //     this.preview_img = preview_img;
    //     this.url = url;
    //     this.price = price;
    //     this.tags = tags;
    //     this.score = score.toFixed(1);
    //     // this.score = Number(((score / 100) * 5).toFixed(1));
    //     this.game_row = null;
    //     this.description = description;
    //     this.big_description = big_description;
    //     this.in_cart = false;
    //     this._add_to_cart_button = null;
    // }

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
    }

    //Определение цвета оценки по числу (0 - красный, 5 - зеленый)
    getScoreColor(score) {
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

    buy() {
        // cart_of_games.push(this);
        this.inCart = true;
        // this._add_to_cart_button.innerHTML = "<span>Удалить из корзины</span>";
        // this._add_to_cart_button.className = "remove-from-cart";
    }

    // удаление из корзины
    removeFromCart() {
        // cart_of_games.splice(cart_of_games.indexOf(this), 1);
        this.inCart = false;
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
        let game_row = $(
            '<div class="game-row" style="z-index: 1">' +
            '  <a href="/programs/' + this.id + '" class="preview" target="_blank" class="description">' +
            '    <img class="preview" src="' + this.headerUrl + '" /></a>' +
            '	<a href="/programs/' + this.id + '" target="_blank" class="description">' +
            '		<div>' +
            '			<span class="name">' + this.name + '</span>' +
            '			<br />' +
            '			<span class="tags">' + this.tagsAsString + '</span>' +
            '		</div>' +
            '        <span class="score" title="Оценка пользователей" style="color: ' + this.getScoreColor(this.averageEstimation) + '">' + this.averageEstimation + '</span>' +
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

        return game_row;
    }

    get_cart_game_row() {
        let cart_game_row = document.createElement("div");
        let cart_game_preview = document.createElement("img");
        let cart_game_description = document.createElement("a");
        let cart_game_title = document.createElement("span");
        let cart_game_price = document.createElement("div");
        let cart_game_price_title = document.createElement("span");
        let cart_game_remove = document.createElement("button");

        cart_game_row.className = "cart-game-row";
        cart_game_preview.className = "preview";
        cart_game_description.className = "cart-game-description";
        cart_game_title.className = "cart-game-title";
        cart_game_price.className = "cart-game-price";
        cart_game_price_title.className = "cart-game-price-title";
        cart_game_remove.className = "cart-game-remove button close-button-bright";

        cart_game_preview.src = this.preview_img;
        cart_game_description.href = this.url;
        cart_game_title.innerHTML = this.name;
        cart_game_price_title.innerHTML = this.price > 0 ? this.price + " руб." : "Бесплатно";
        cart_game_remove.onclick = () => {
            this.removeFromCart();
            show_cart();
        };

        cart_game_description.append(cart_game_title);
        cart_game_price.append(cart_game_price_title, cart_game_remove);
        cart_game_row.append(cart_game_preview, cart_game_description, cart_game_price);

        return cart_game_row;
    }

    setProgramPage() {
        $("#page-title").html("Soft Depot - " + this.name);
        $(".header").attr("src", this.headerUrl);
        $("#short-description").html(this.shortDescription);
        $(".game-name").html(this.name);
        $("#score").html(this.averageEstimation);
        $("#score").attr("style", "color: " + this.getScoreColor(this.averageEstimation));
        $("#description-text").html(this.fullDescription);
        $("#price").html(this.priceAsString);
        $(".add-to-cart").attr("program-id", this.id);

        let first = true;
        this.screenshotsUrl.forEach((img) => {
            let screenshot = $('<img className="screenshot-on-tape" src="' + img + '" onClick="change_current_screenshot.apply(this)"/>');
            if (first) {
                $(".screenshots-viewer").append('<img id="current-screenshot" src="'+img+'" />');
                first = false;
            }
            $(".screenshots-tape").append(screenshot);
        });

    }
}
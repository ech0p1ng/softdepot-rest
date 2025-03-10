const ERROR_MESSAGE_STYLE_VISIBLE = {
    "font-size": "8pt",
    "color": "var(--red)"
};
const ERROR_MESSAGE_STYLE_HIDDEN = {
    "font-size": "0pt",
    "color": "var(--red)"
};
const HINT_MESSAGE_STYLE_VISIBLE = {
    "font-size": "8pt",
    "color": "var(--secondary-text-color)",
};
const HINT_MESSAGE_STYLE_HIDDEN = {
    "font-size": "0pt",
    "color": "var(--secondary-text-color)"
};

let STAR_FILL = null;
let STAR_OUTLINE = null;

let MAX_REVIEW_LENGTH = 2500;

let starsLoaded = false;
$(window).on('load', function () {
    let starFillLoaded = false;
    let starOutlineLoaded = false;

    //загрузка SVG изображений звезд
    $.ajax({
        url: '/styles/svg/star-fill.svg',
        method: 'GET',
        dataType: 'html',
        success: function (svg) {
            STAR_FILL = svg;
            starFillLoaded = true;
        },
        error: function (xhr, msg, status) {
            console.error(msg);
        },
        complete: function () {
            $.ajax({
                url: '/styles/svg/star-outline.svg',
                method: 'GET',
                dataType: 'html',
                success: function (svg) {
                    STAR_OUTLINE = svg;
                    starOutlineLoaded = true;
                },
                error: function (xhr, msg, status) {
                    console.error(msg);
                },
                complete: function () {
                    if (starFillLoaded && starOutlineLoaded) {
                        $(document).trigger('starsLoaded');
                        starsLoaded = true;
                        console.log('Звезды загрузились!');
                    }
                    else {
                        console.error("Не удалось загрузить звезды для отзывов :(");
                    }
                }
            });
        }
    });



    function addStar(id, svgStar, inputJuqeryItem) {
        let starButton = $(/*html*/`
            <div class="estimation-button" estimation-button-id=${id}>${svgStar}</div>
        `);

        starButton.css("color", Program.getScoreColor(5));

        starButton.on('click', function () {
            Review.estimation = parseInt($(this).attr('estimation-button-id')) + 1;
            for (let i = 0; i < 5; i++) {
                if (i < Review.estimation)
                    $('[estimation-button-id="' + i + '"]').html(STAR_FILL);
                else
                    $('[estimation-button-id="' + i + '"]').html(STAR_OUTLINE);
            }

            $('.estimation-button').css("color", Program.getScoreColor(Review.estimation));
        });

        inputJuqeryItem
            .find('.review-estimation')
            .append(starButton);
    }

    Review.inputJqueryItem = $(/*html*/`
        <div id="review-input-item">
        <div class="review-estimation"></div>
            <div>
                <textarea class="input multi-line-input" id="current-user-review-input" title="Оставьте свой отзыв" placeholder="Оставьте свой отзыв"></textarea>
                <span type="text" class="msg-under-input" id="reviewTextHint"></span>
            </div>
            <div class="send-review-footer">
                <button class="button" id="send-review-button"><span>Отправить отзыв</span></button>
            </div>
        </div>
    `);

    $(document).on('starsLoaded', function () {
        for (let i = 0; i < 5; i++) {
            addStar(i, STAR_FILL, Review.inputJqueryItem);
        }
    });

    Review.inputJqueryItem.find("#current-user-review-input").on('input', function () {
        this.value = limitTextInput(
            $(this),
            this.value,
            MAX_REVIEW_LENGTH,
            $("#reviewTextHint")
        );
    });


    Review.inputJqueryItem.find("#send-review-button").on('click', function () {
        Review.text = $("#current-user-review-input").val().trim();
        $("#current-user-review-input").val(Review.text);

        if (Review.text.length === 0) {
            highlightInputOnError(
                $("#current-user-review-input"),
                $("#reviewTextHint"),
                "Введите текст отзыва"
            )
        }
    });
});


function highlightInputOnError(inputJqueryItem, msgSpanJqueryItem, message = "") {
    inputJqueryItem.css({ "box-shadow": "inset 0 0 0 2px var(--red)" });
    msgSpanJqueryItem.css(ERROR_MESSAGE_STYLE_VISIBLE);
    if (message != "") {
        msgSpanJqueryItem.html(message);
    }
}

function removeInputHighlight(inputJqueryItem, msgSpanJqueryItem) {
    inputJqueryItem.css({ "box-shadow": "none" });
    msgSpanJqueryItem.css(ERROR_MESSAGE_STYLE_HIDDEN)
}

function limitTextInput(inputJquertItem, value, maxLength, hintJqueryItem) {
    removeInputHighlight(inputJquertItem, hintJqueryItem);
    if (value.length > maxLength) {
        value = value.substring(0, maxLength);
        highlightInputOnError(
            inputJquertItem,
            hintJqueryItem,
            value.length + "/" + maxLength
        )
    }
    else if (value.length >= maxLength * 0.7) {
        hintJqueryItem
            .css(HINT_MESSAGE_STYLE_VISIBLE)
            .html(value.length + "/" + maxLength);
    }
    else {
        hintJqueryItem.css(HINT_MESSAGE_STYLE_HIDDEN);
    }
    return value;
}

class Review {
    static inputJqueryItem;
    static estimation = 5;
    static text = 5;
    static userId;
    static programId;

    constructor(response) {
        this.id = response.id;
        this.customer = new User(response.customer);
        this.program = new Program(response.program);
        this.estimation = response.estimation;
        this.reviewText = response.reviewText;
        this.dateTime = response.dateTime;
        this.programName = response.programName;
        this.customerId = response.customerId;
        this.programId = response.programId;

        this.reviewRow = $(/*html*/`
            <div class="review">
                <a class="review-user" href="${this.customer.pageUrl}">
                    <img class="review-user-profile-img" src="${this.customer.profileImgUrl}" />
                    <span class="review-username">${this.customer.name}</span>
                </a>
                <br />
                <div class="review-estimation" style="color: ${Program.getScoreColor(this.estimation)}"></div>
                <br />
                <span class="review-text">${this.reviewText}</span>
            </div>
        `);

        this.reviewRowAtUserPage = $(/*html*/`
            <div class="review">
                <a href="${this.program.pageUrl}" class="review-program" target="_blank" >
                    <img class="review-program-preview" src="${this.program.headerUrl}" title="${this.program.name}">
                    <span class="review-program-name">${this.program.name}</span>
                </a>
                <br />
                <div class="review-estimation" style="color: ${Program.getScoreColor(this.estimation)}"></div>
                <br />
                <span class="review-text">${this.reviewText}</span>
            </div>
        `);




    }

    addStars() {
        for (let i = 0; i < this.estimation; i++) {
            this.reviewRow
                .find(".review-estimation")
                .append(STAR_FILL);
            this.reviewRowAtUserPage
                .find(".review-estimation")
                .append(STAR_FILL);
        }
        for (let i = 0; i < 5 - this.estimation; i++) {
            this.reviewRow
                .find(".review-estimation")
                .append(STAR_OUTLINE);
            this.reviewRowAtUserPage
                .find(".review-estimation")
                .append(STAR_OUTLINE);
        }
    }

    getReviewRow() {
        if (starsLoaded) {
            this.addStars();
            return this.reviewRow;
        }
        else {
            $(document).on('starsLoaded', () => {
                this.addStars();
            });
            return this.reviewRow;
        }
    }

    getReviewRowAtUserPage() {
        if (starsLoaded) {
            this.addStars();
            return this.reviewRowAtUserPage;
        }
        else {
            $(document).on('starsLoaded', () => {
                this.addStars();
            });
            return this.reviewRowAtUserPage;
        }
    }
}

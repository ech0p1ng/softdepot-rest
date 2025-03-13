const MIN_PROGRAM_NAME_LENGTH = 3;
const MAX_RROGRAM_NAME_LENGTH = 100;

const MIN_SHORT_DESCRIPTION_LENGTH = 5;
const MAX_SHORT_DESCRIPTION_LENGTH = 250;

const MIN_FULL_DESCRIPTION_LENGTH = 200;
const MAX_FULL_DESCRIPTION_LENGTH = 2500;

const MIN_PROGRAM_PRICE = 0;
const MAX_PROGRAM_PRICE = 1000000;

const MIN_DEGREE_OF_BELONGING = 0;
const MAX_DEGREE_OF_BELONGING = 10;

const MIN_CATEGORIES_AMOUNT = 1;
const MIN_SCREENSHOTS_AMOUNT = 3;

const ACCEPTABLE_FILE_TYPES = ".png,.jpg,.jpeg,.webp";

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

const BACKEND_URL = "http://127.0.0.1:8080/";
let USER = null;

function addHeader(addSearchForm, addProfileButton) {
    let header = $(
        '<header>' +
        '    <div class="header-buttons">' +
        '        <a id="main-button" class="button" href="/">' +
        '            <div class="logo"></div>' +
        '            <span class="store-name" title="SOFT DEPOT">SOFT DEPOT</span>' +
        '        </a>' +
        '        <div class="right-buttons-panel">' +
        '            <button class="change-theme button" title="Сменить тему" onclick="change_theme()"></button>' +
        '        </div>' +
        '    </div>' +
        '</header>'
    );

    if (addSearchForm) {
        header.prepend(
            '<form method="get" id="search-form">' +
            '    <div class="loupe"></div>' +
            '    <input id="search" placeholder="Поиск..."/>' +
            '</form>'
        );
    }

    if (addProfileButton) {
        header
            .find(".right-buttons-panel")
            .append('<a id="user-profile-button" class="login button" title="Войти" href="/sign-in"></a>');
    }

    $(window).on('userDataLoaded', () => {
        if (USER !== null) {
            if (USER.hasPurchasedPrograms) {
                header
                    .find(".right-buttons-panel")
                    .prepend(/*html*/`
                    <a href="/recommendations" id="recommendations-button" class="button" title="Рекомендации"></a>
                `);
            }
        }
    });
    $("body").prepend(header);
}

function convertToNumber(str, { onError, onErrorResolved }, minValue = -Infinity,
    maxValue = Infinity) {
    let result = "";
    if (str === "") str = "0";

    //удаление всех символов помимо цифр
    for (let i = 0; i < str.length; i++) {
        let item = str[i];
        let parseable = !isNaN(parseFloat(item));
        if (parseable) {
            if (parseInt(item) >= 0 && parseInt(item) < 10) {
                result += item
            }
        }
    }
    //удаление нулей в начале и укорачивание до двух символов
    result = parseInt(result).toString();

    if (isNaN(result)) {
        return 0;
    }

    if (minValue != -Infinity && maxValue != Infinity) {
        let maxLength = maxValue.toString().length;

        if (result >= minValue && result <= maxValue) {
            if (onErrorResolved) onErrorResolved();
        }
        else {
            result = result.substring(0, result.length - 1);
            if (onError) onError();
        }
    }
    return result;

}
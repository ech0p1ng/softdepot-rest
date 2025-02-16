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

// $(document).on('input', 'input[type="number"][number-type="float"]', function () {
//     this.value = convertToNumber(this.value.toString());
// });

// $(document).on('input', 'input[type="number"][number-type="int"]', function () {
//     this.value = convertToNumber(this.value.toString());
// });
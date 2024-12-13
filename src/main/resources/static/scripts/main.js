const BACKEND_URL = "http://127.0.0.1:8080/";

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
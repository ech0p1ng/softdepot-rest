function change_theme() {
    var next_theme = localStorage.getItem("color-scheme");
    if (next_theme === "dark") {
        let theme = document.getElementById("color-scheme");
        theme.setAttribute("href", "styles/dark.css");
        localStorage.setItem("color-scheme", "light");
    } else {
        let theme = document.getElementById("color-scheme");
        theme.setAttribute("href", "styles/light.css");
        localStorage.setItem("color-scheme", "dark");
    }
}

window.onload = () => {
    var next_theme = localStorage.getItem("color-scheme");
    if (next_theme === "dark") {
        let theme = document.getElementById("color-scheme");
        theme.setAttribute("href", "styles/light.css");
    } else {
        let theme = document.getElementById("color-scheme");
        theme.setAttribute("href", "styles/dark.css");
    }

    let games_list_elem = document.getElementById("games-list");

    $.ajax({
        method: "GET",
        url: "http://127.0.0.1:8080/softdepot-api/products",
        // contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (data) {
            data.forEach((element) => {
                let game = new Game(element.name, element.logoUrl, element.id, element.price, "", element.averageEstimation, element.shortDescription, element.fullDescription);
                games_list_elem.append(game.getGameRowPreview());
            });
        },
    });

    // games_list.forEach((game) => {
    //     games_list_elem.append(game.getGameRowPreview());
    // });
};

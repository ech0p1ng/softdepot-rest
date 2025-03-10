const DARK_THEME_CSS = "/styles/dark.css";
const LIGHT_THEME_CSS = "/styles/light.css";

function change_theme() {
    let theme = getCookie("theme");
    if (theme === "dark") setCookie("theme", "light", 0);
    if (theme === "light") setCookie("theme", "dark", 0);
    setTheme();
}

function setTheme() {
    let theme = getCookie("theme");
    console.log("cookie = ", theme);
    if (theme == null) {
        theme = "dark";
        setCookie("theme", "dark", 0);
    }
    if (theme === "dark") $("#color-scheme").attr("href", DARK_THEME_CSS);
    if (theme === "light") $("#color-scheme").attr("href", LIGHT_THEME_CSS);
}

window.addEventListener("load", setTheme);
let darkthemecss = "/styles/dark.css";
let lightthemecss = "/styles/light.css";

function change_theme() {
    var next_theme = localStorage.getItem("color-scheme");
    if (next_theme === "dark") {
        let theme = document.getElementById("color-scheme");
        theme.setAttribute("href", darkthemecss);
        localStorage.setItem("color-scheme", "light");
    } else {
        let theme = document.getElementById("color-scheme");
        theme.setAttribute("href", lightthemecss);
        localStorage.setItem("color-scheme", "dark");
    }
}

window.onload = () => {
    var next_theme = localStorage.getItem("color-scheme");
    if (next_theme === "dark") {
        let theme = document.getElementById("color-scheme");
        theme.setAttribute("href", lightthemecss);
    } else {
        let theme = document.getElementById("color-scheme");
        theme.setAttribute("href", darkthemecss);
    }
};

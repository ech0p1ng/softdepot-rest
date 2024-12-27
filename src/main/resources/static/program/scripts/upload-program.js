class UploadProgram {
    static categories = [];
    static show() {

    }

    static close() {

    }

    static getCategories() {
        $.ajax({
            method: "GET",
            url: BACKEND_URL + "softdepot-api/categories",
            dataType: "json",
            success: (response) => {
                response.forEach((elem) => {
                    this.categories.push(new Tag(elem));
                });
            },
            error: (xhr, status, error) => {
                alert("Не удалось загрузить список категорий программ. Перезагрузите страницу или повторите позже.");
            }
        });
    }

    static getCategorySelect(category) {
        return $(`<option value="${category.id}" class=".select-option">${category.name}</option>`);
    }
}
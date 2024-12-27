var selectsForCategoriesCount = 0;

class UploadProgram {
    static categories = [];

    static show() {
        this.loadCategories();
        this.addSelectRow();
    }


    static close() { }

    static getOptionForSelect(category) {
        return $(/*html*/
            `<option value="${category.id}" class=".select-option">${category.name}</option>`
        );
    }

    static loadCategories() {
        $.ajax({
            method: 'GET',
            url: BACKEND_URL + 'softdepot-api/categories?sortBy=name',
            dataType: 'json',
            success: (response) => {
                response.forEach((elem) => {
                    this.categories.push(this.getOptionForSelect(new Tag(elem)));
                });
            },
            error: (xhr, status, error) => {
                alert('Не удалось загрузить список категорий программ. Перезагрузите страницу или повторите позже.');
            },
        });
    }


    static addSelectRow() {
        let selectRow = $(/*html*/
            `<div class="category-select-row" id="category-select-row-${selectsForCategoriesCount}">
                <select class="select pop-up-select-input" name="category-select-${selectsForCategoriesCount}">
                    <option value="" class=".select-option" disabled selected>Выберите категорию...</option>
                </select>
                <input id="category-degree-of-belonging-${selectsForCategoriesCount}" class="input pop-up-one-line-input" type="number" placeholder="Степень принадлежности" title="Степень принадлежности программы к категории" min="0" max="10" step="1">
                <button class="button exit-button close-button remove-button" id="remove-category-button-${selectsForCategoriesCount}" title="Удалить категорию" row-id="${selectsForCategoriesCount}" onclick="UploadProgram.deleteSelectRow(${selectsForCategoriesCount})"></button>
            </div>`
        );

        selectRow
            .find(`.category-select-row.remove-button`)
            .on('click', this.deleteSelectRow.bind(this));


        selectsForCategoriesCount++;

        let select = selectRow.find(`select`);

        this.categories.forEach(categoryOption => {
            select.push(categoryOption);
        });

        $(".categories-selects").append(selectRow);
        let currentScrollTop = $('.pop-up-main').scrollTop();
        let heigth = $('.category-select-row').outerHeight(true);
        $('.pop-up-main').scrollTop(currentScrollTop + heigth);
    }

    static deleteSelectRow(rowId) {
        $(`#category-select-row-${rowId}`).remove();
    }
}

$(window).on('load', () => {
    UploadProgram.show();
    $("#add-category-button").on('click', () => UploadProgram.addSelectRow());

    //предпросмотр лого
    $("#add-logo-button").on('change', () => {
        const filesList = $("#add-logo-button").prop('files');
        let previewContainer = $('.preview-container');
        previewContainer.empty();


        for (let file of filesList) {
            if (file.type.startsWith('image/')) {
                let reader = new FileReader();

                reader.onload = function (event) {
                    let img = $('<img>')
                        .attr('src', event.target.result)
                        .addClass('logo-preview');
                    previewContainer.append(img);
                    $("#add-logo-container span").html('Заменить логотип');
                }

                reader.onerror = function (event) {
                    alert(event.target.error);
                }

                reader.onprogress = function (event) {
                    $("#add-logo-container span").html('Загрузка...');
                    if (event.lengthComputable) {
                        const percentLoaded = Math.round((event.loaded / event.total) * 100);
                        console.log(percentLoaded);
                    }
                }

                reader.readAsDataURL(file);
            }
        }
    });
});

var selectsForCategoriesCount = 0;

const ImageType = {
    SCREENSHOTS: 'SCREENSHOTS',
    LOGO: 'LOGO'
}

class UploadProgram {
    static categories = [];

    static show() {
        $.ajax({
            method: 'GET',
            url: BACKEND_URL + 'softdepot-api/categories?sortBy=name',
            dataType: 'json',
            success: (response) => {
                response.forEach((elem) => {
                    UploadProgram.categories.push(new Tag(elem));
                });
                UploadProgram.addSelectRow();
            },
            error: (xhr, status, error) => {
                alert('Не удалось загрузить список категорий программ. Перезагрузите страницу или повторите позже.');
            },
        });
    }


    static close() { }



    static addSelectRow() {
        let selectRow = $(/*html*/
            `<div class="category-select-row" id="category-select-row-${selectsForCategoriesCount}">
                <select class="select pop-up-select-input" name="category-select-${selectsForCategoriesCount}">
                    <option value="" class="select-option" disabled selected>Выберите категорию...</option>
                </select>
                <input id="category-degree-of-belonging-${selectsForCategoriesCount}" class="input pop-up-one-line-input" type="number" placeholder="Степень принадлежности" title="Степень принадлежности программы к категории" min="0" max="10" step="1">
                <button class="button exit-button close-button remove-button" id="remove-category-button-${selectsForCategoriesCount}" title="Удалить категорию" row-id="${selectsForCategoriesCount}" onclick="UploadProgram.deleteSelectRow(${selectsForCategoriesCount})"></button>
            </div>`
        );

        selectRow
            .find(`.category-select-row.remove-button`)
            .on('click', this.deleteSelectRow.bind(this));


        selectsForCategoriesCount++;

        UploadProgram.categories.forEach(category => {

            let option = $(/*html*/
                `<option value="${category.id}" class="select-option">${category.name}</option>`
            );

            selectRow.find('select').append(option);
            console.log(category.name);
        });

        $(".categories-selects").append(selectRow);
        let currentScrollTop = $('.pop-up-main').scrollTop();
        let heigth = $('.category-select-row').outerHeight(true);
        $('.pop-up-main').scrollTop(currentScrollTop + heigth);
    }

    static deleteSelectRow(rowId) {
        $(`#category-select-row-${rowId}`).remove();
    }

    static addImage(previewContainer, addImageButton, defaultImageTextFunc, changeImageTextFunc, loadingImageTextFunc, imageType) {
        const filesList = addImageButton.prop('files');
        // let previewContainer = $('#logo-preview-container');
        // previewContainer.empty();


        for (let file of filesList) {
            if (file.type.startsWith('image/')) {
                let reader = new FileReader();

                reader.onload = function (event) {
                    // let imgPreviewContainer = $(/*html*/
                    //     `<img src="${event.target.result}" class="image-preview">
                    //     <br/>`
                    // );

                    let imgPreviewContainer = $(/*html*/
                        `
                        <div class="image-preview-container">
                            <img src="${event.target.result}" class="image-preview">
                            <div class="buttons-block">
                                <button class="button edit-button edit" title="Заменить изображение"></button>
                                <button class="button exit-button close-button" title="Удалить изображение"></button>
                            </div>
                        </div>
                        `
                    )

                    if (imageType === ImageType.LOGO) {
                        let img = new Image();

                        img.onload = function () {
                            if (img.width !== img.height) {
                                defaultImageTextFunc();
                                alert("Ширина и высота изображения для логотипа должны быть равны");
                            }
                            else {
                                changeImageTextFunc();
                            }
                        }

                        img.src = event.target.result;
                    }
                    else if (imageType === ImageType.SCREENSHOTS) {
                        changeImageTextFunc();
                    }
                    previewContainer.append(imgPreviewContainer);

                }

                reader.onerror = function (event) {
                    alert(event.target.error);
                }

                reader.onprogress = function (event) {
                    // $("#add-logo-container span").html('Загрузка...');
                    loadingImageTextFunc();
                    if (event.lengthComputable) {
                        const percentLoaded = Math.round((event.loaded / event.total) * 100);
                        console.log(percentLoaded);
                    }
                }

                reader.readAsDataURL(file);

            }
        }
    }
}

$(window).on('load', () => {
    UploadProgram.show();
    $("#add-category-button").on('click', () => UploadProgram.addSelectRow());


    $("#add-logo-button").on('change', () => {
        $("#add-logo-button").empty();
        UploadProgram.addImage(
            $('#logo-preview-container'),
            $('#add-logo-button'),
            function () {
                $("#add-logo-container span").html('Добавить логотип')
            },
            function () {
                $("#add-logo-container span").html('Заменить логотип')
            },
            function () {
                $("#add-logo-container span").html('Загрузка...')
            },
            ImageType.LOGO
        );
    });

    $("#add-screenshots-button").on("change", () => {
        UploadProgram.addImage(
            $('#screenshots-preview-container'),
            $('#add-screenshots-button'),
            function () {
                $("#add-screenshots-container span").html('Добавить скриншоты')
            },
            function () {
                $("#add-screenshots-container span").html('Заменить скриншоты')
            },
            function () {
                $("#add-screenshots-container span").html('Загрузка...')
            },
            ImageType.SCREENSHOTS
        )
    });

});

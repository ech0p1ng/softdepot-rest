var selectsForCategoriesCount = 0;

const ImageType = {
    SCREENSHOTS: 'SCREENSHOTS',
    LOGO: 'LOGO'
}

class ProgramUploader {
    static categories = [];

    static show() {
        $.ajax({
            method: 'GET',
            url: BACKEND_URL + 'softdepot-api/categories?sortBy=name',
            dataType: 'json',
            success: (response) => {
                response.forEach((elem) => {
                    ProgramUploader.categories.push(new Tag(elem));
                });
                ProgramUploader.addSelectRow();
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
                <select class="select pop-up-select-input" name="category-select">
                    <option value="" class="select-option" disabled selected>Выберите категорию...</option>
                </select>
                <input id="category-degree-of-belonging-${selectsForCategoriesCount}" class="input pop-up-one-line-input" type="number" placeholder="Степень принадлежности" title="Степень принадлежности программы к категории" min="0" max="10" step="1" name="category-degree-of-belonging">
                <button class="button exit-button close-button remove-button" id="remove-category-button-${selectsForCategoriesCount}" title="Удалить категорию" row-id="${selectsForCategoriesCount}" onclick="ProgramUploader.deleteSelectRow(${selectsForCategoriesCount})"></button>
            </div>`
        );

        selectRow
            .find(`.category-select-row.remove-button`)
            .on('click', this.deleteSelectRow.bind(this));


        selectsForCategoriesCount++;

        ProgramUploader.categories.forEach(category => {

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

    static collectInfo() {
        let kitem = $("#programName");
        let programName = $("#programName").val();
        let shortDescription = $("#shortDescription").val();
        let fullDescription = $("#fullDescription").val();
        let price = $("#price").val();

        let categoriesRows = $(".categories-selects").find('.category-select-row');

        categoriesRows.each(function () {
            let categoryId = $(this).find('[name="category-select"]').val();
            let categoryName = $(this).find('[name="category-select"]').text();
            let degreeOfBelonfing = $(this).find('[name="category-degree-of-belonging"]').val();
            alert(categoryName);
            // let category = new Tag();
        })

    }
}

$(window).on('load', () => {
    ProgramUploader.show();
    $("#add-category-button").on('click', () => ProgramUploader.addSelectRow());


    $("#add-logo-button").on('change', () => {
        $("#add-logo-button").empty();
        ProgramUploader.addImage(
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
        ProgramUploader.addImage(
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

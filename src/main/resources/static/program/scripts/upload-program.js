var selectsForCategoriesCount = 0;

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

const ImageType = {
    SCREENSHOTS: 'SCREENSHOTS',
    LOGO: 'LOGO'
}

class ProgramUploader {
    static categories = [];

    static show() {
        $("#price").on('input', function () {
            console.log(this.value);
            let result = convertToNumber(
                this.value,
                {
                    "onError": () => highlightInputOnError($("#price"), $("#priceHint")),
                    "onErrorResolved": () => removeInputHighlight($("#price"), $("#priceHint"))
                },
                MIN_PROGRAM_PRICE,
                MAX_PROGRAM_PRICE,
            );
            this.value = result;

            $("#priceHint").html(`Цена должна быть от ${MIN_PROGRAM_PRICE} до ${MAX_PROGRAM_PRICE} руб.`)

        });


        $("#programName").on('input', function () {
            this.value = limitTextInput(
                this.value,
                MAX_RROGRAM_NAME_LENGTH,
                $("#programNameHint")
            );
        });


        $("#shortDescription").on('input', function () {
            this.value = limitTextInput(
                this.value,
                MAX_SHORT_DESCRIPTION_LENGTH,
                $("#shortDescriptionHint")
            );
        });


        $("#fullDescription").on('input', function () {
            this.value = limitTextInput(
                this.value,
                MAX_FULL_DESCRIPTION_LENGTH,
                $("#fullDescriptionHint")
            );
        });


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
                <select class="select pop-up-select-input" name="category-select" title="Выберите категорию">
                    <option value="" class="select-option" disabled selected>Выберите категорию...</option>
                </select>
                <input id="category-degree-of-belonging-${selectsForCategoriesCount}" class="input pop-up-one-line-input only-int-input" type="number" placeholder="Степень принадлежности (от ${MIN_DEGREE_OF_BELONGING} до ${MAX_DEGREE_OF_BELONGING})" title="Степень принадлежности программы к категории (число от ${MIN_DEGREE_OF_BELONGING} до ${MAX_DEGREE_OF_BELONGING})" min="${MIN_DEGREE_OF_BELONGING}" max="${MAX_DEGREE_OF_BELONGING}" step="1" name="category-degree-of-belonging">
                <button class="button exit-button close-button remove-button" id="remove-category-button-${selectsForCategoriesCount}" title="Удалить категорию" row-id="${selectsForCategoriesCount}" onclick="ProgramUploader.deleteSelectRow(${selectsForCategoriesCount})"></button>
            </div>`
        );

        selectRow
            .find(`.category-select-row.remove-button`)
            .on('click', this.deleteSelectRow.bind(this));

        selectRow
            .find('input')
            .on("input", function () {
                this.value = convertToNumber(
                    this.value.toString(),
                    {
                        'onError': () => { },
                        'onErrorResolved': () => { }
                    },
                    MIN_DEGREE_OF_BELONGING,
                    MAX_DEGREE_OF_BELONGING);
            });


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

    static uploadProgram() {
        let programName = $("#programName").val();
        let shortDescription = $("#shortDescription").val();
        let fullDescription = $("#fullDescription").val();
        let price = $("#price").val();

        let categoriesRows = $(".categories-selects").find('.category-select-row');

        let choosenCategories = [];

        categoriesRows.each(function () {
            let categoryId = $(this).find('[name="category-select"]').val();
            let categoryName = $(this).find('[name="category-select"]').find('option:selected').text();
            let degreeOfBelonging = $(this).find('[name="category-degree-of-belonging"]').val();
            if (degreeOfBelonging > 10) degreeOfBelonging = 10;
            else if (degreeOfBelonging < 0) degreeOfBelonging = 0;

            let category = new Tag({
                "id": categoryId,
                "name": categoryName,
                "degreeOfBelonging": degreeOfBelonging,
                "programId": null
            });
            if (!choosenCategories.includes(category)) {
                choosenCategories.push(category);
            }
            else {
                alert("Удалите дубликаты категорий");
                return;
            }
        });

        programName = programName.trim();
        shortDescription = shortDescription.trim()
        fullDescription = fullDescription.trim();

        let nameIsGood = programName.length > 3;
        let shortDescriptionIsGood =
            shortDescription.length > MIN_SHORT_DESCRIPTION_LENGTH &&
            shortDescription.length <= MAX_SHORT_DESCRIPTION_LENGTH;
        let fullDescriptionIsGood =
            fullDescription.length > MIN_FULL_DESCRIPTION_LENGTH &&
            fullDescription.length <= MAX_FULL_DESCRIPTION_LENGTH;

        // if (USER == null) {
        //     alert("Авторизируйтесь!")
        // }
        // else {
        //     if (USER.type === "Developer") {
        let program = {
            // "developerId": USER.id,
            "developerId": 1,
            "name": programName,
            "shortDescription": shortDescription,
            "fullDescription": fullDescription,
            "price": price,
            "categories": categories,
            "logo": null,
            "screenshots": null
        }

        let response = JSON.stringify(program);
        console.log(response);
        // }
        // else {
        //     alert(`Недопустимое действие. Ваша роль ${USER.type}, а должна быть "Developer"`);
        // }
        // }

    }
}

function highlightInputOnError(inputJqueryItem, msgSpanJqueryItem) {
    inputJqueryItem.css({ "box-shadow": "inset 0 0 0 2px var(--red)" });
    msgSpanJqueryItem.css(ERROR_MESSAGE_STYLE_VISIBLE);
}

function removeInputHighlight(inputJqueryItem, msgSpanJqueryItem) {
    inputJqueryItem.css({ "box-shadow": "none" });
    msgSpanJqueryItem.css(ERROR_MESSAGE_STYLE_HIDDEN)
}

function limitTextInput(value, maxLength, hintJqueryItem) {
    if (value.length > maxLength) {
        value = value.substring(0, maxLength);
    }
    else if (value.length >= maxLength * 0.7) {
        hintJqueryItem
            .css(HINT_MESSAGE_STYLE_VISIBLE)
            .html(value.length + "/" + maxLength);
    }
    else {
        hintJqueryItem.css(HINT_MESSAGE_STYLE_HIDDEN);
    }
    return value;
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


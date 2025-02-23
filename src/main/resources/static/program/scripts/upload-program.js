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

const MIN_CATEGORIES_AMOUNT = 3;

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

const PRICE_MSG = `Цена должна быть от ${MIN_PROGRAM_PRICE} до ${MAX_PROGRAM_PRICE} руб.`

class ProgramUploader {
    static logoLastId = 0;
    static screenshotLastId = 0;

    static logo = null;

    static screenshots = [];

    static categories = [];

    static show() {
        $("#price").on('input', function () {
            // console.log(this.value);
            let result = convertToNumber(
                this.value,
                {
                    "onError": () => highlightInputOnError($("#price"), $("#priceHint"), PRICE_MSG),
                    "onErrorResolved": () => removeInputHighlight($("#price"), $("#priceHint"))
                },
                MIN_PROGRAM_PRICE,
                MAX_PROGRAM_PRICE,
            );
            this.value = result;
        });


        $("#programName").on('input', function () {
            this.value = limitTextInput(
                $(this),
                this.value,
                MAX_RROGRAM_NAME_LENGTH,
                $("#programNameHint")
            );
        });


        $("#shortDescription").on('input', function () {
            this.value = limitTextInput(
                $(this),
                this.value,
                MAX_SHORT_DESCRIPTION_LENGTH,
                $("#shortDescriptionHint")
            );
        });


        $("#fullDescription").on('input', function () {
            this.value = limitTextInput(
                $(this),
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
                ProgramUploader.addSelectRow(false);
            },
            error: (xhr, status, error) => {
                alert('Не удалось загрузить список категорий программ. Перезагрузите страницу или повторите позже.');
            },
        });
    }

    static close() { }

    static addSelectRow(scroll = true) {
        let selectRow = $(/*html*/
            `<div id="category-selector-${selectsForCategoriesCount}">
                <div class="category-select-row" id="category-select-row-${selectsForCategoriesCount}">
                    <select class="select pop-up-select-input" name="category-select" title="Выберите категорию">
                        <option value="" class="select-option" disabled selected>Выберите категорию...</option>
                    </select>
                    <input id="category-degree-of-belonging-${selectsForCategoriesCount}" class="input pop-up-one-line-input only-int-input" type="number" placeholder="Степень принадлежности (от ${MIN_DEGREE_OF_BELONGING} до ${MAX_DEGREE_OF_BELONGING})" title="Степень принадлежности программы к категории (число от ${MIN_DEGREE_OF_BELONGING} до ${MAX_DEGREE_OF_BELONGING})" min="${MIN_DEGREE_OF_BELONGING}" max="${MAX_DEGREE_OF_BELONGING}" step="1" name="category-degree-of-belonging">
                    <button class="button exit-button close-button remove-button" id="remove-category-button-${selectsForCategoriesCount}" title="Удалить категорию" row-id="${selectsForCategoriesCount}" onclick="ProgramUploader.deleteSelectRow(${selectsForCategoriesCount})"></button>
                </div>
                <span type="text" class="msg-under-input category-select-row-hint" id="category-select-row-${selectsForCategoriesCount}-hint"></span>
            </div>`
        );

        // selectRow
        //     .find(`.category-select-row.remove-button`)
        //     .on('click', this.deleteSelectRow.bind(this));

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
            // console.log(category.name);
        });

        $(".categories-selects").append(selectRow);
        if (scroll) {
            let currentScrollTop = $('.pop-up-main').scrollTop();
            let heigth = $('.category-select-row').outerHeight(true);
            $('.pop-up-main').scrollTop(currentScrollTop + heigth);
        }
    }

    static deleteSelectRow(rowId) {
        $(`#category-selector-${rowId}`).remove();
    }

    static removeImage(id, previewContainer, addImageButton, imageType) {
        // let files = addImageButton.prop('files');
        // let newFiles = Array.from(files).splice(id, 1);

        // const dataTransfer = new DataTransfer();
        // newFiles.forEach(file => dataTransfer.items.add(file));
        // addImageButton.files = dataTransfer.files;



        // previewContainer.empty();
        previewContainer.empty();
        if (imageType === ImageType.LOGO) {
            ProgramUploader.logo = null;
            // previewContainer.find(`[logo-id="${id}"]`).remove();

        }
        else if (imageType === ImageType.SCREENSHOTS) {
            ProgramUploader.screenshots.splice(id, 1);
            ProgramUploader.addImagesFromArray(
                ProgramUploader.screenshots,
                previewContainer,
                addImageButton,
                imageType
            )
            // previewContainer.find(`[screenshot-id="${id}"]`).remove();
        }
        // ProgramUploader.screenshots = dataTransfer.files;
        // ProgramUploader.addImagesFromArray(dataTransfer.files, previewContainer, addImageButton, imageType)

    }

    static addImagesFromArray(filesList, previewContainer, addImageButton, imageType) {
        if (imageType === ImageType.LOGO) {
            let id = 0;
            let file = filesList[id];
            if (file.type.startsWith('image/')) {
                let reader = new FileReader();

                reader.onload = function (event) {
                    let img = new Image();
                    img.onload = function () {
                        if (img.width !== img.height) {
                            // defaultImageTextFunc();
                            alert("Ширина и высота изображения для логотипа должны быть равны");
                            // addImageButton.val(''); //очистка добавленных изображений
                        }
                        else {
                            id = ProgramUploader.logoLastId;
                            // changeImageTextFunc();
                            let imgPreview = $(/*html*/`
                                    <div class="image-preview-container" id="logo-preview-container-${id}" logo-id="${id}">
                                        <img src="${event.target.result}" class="image-preview">
                                        <div class="buttons-block">
                                            <button class="button edit-button edit"
                                                    parent-id="logo-preview-container-${id}"
                                                    title="Заменить изображение"
                                                    id="change-logo-${id}-button"
                                                    >
                                            </button>
                                            <button class="button exit-button close-button"
                                                    parent-id="logo-preview-container-${id}"
                                                    title="Удалить изображение"
                                                    id="remove-logo-${id}-button"
                                                    >
                                            </button>
                                        </div>
                                    </div>
                                `);

                            imgPreview
                                .find(`#change-logo-${id}-button`)
                                .on('click', function () {
                                    ProgramUploader.logo = null;
                                    addImageButton.click();
                                    ProgramUploader.removeImage(id, previewContainer, addImageButton, ImageType.LOGO);
                                });

                            imgPreview
                                .find(`#remove-logo-${id}-button`)
                                .on('click', function () {
                                    ProgramUploader.logo = null;
                                    ProgramUploader.removeImage(id, previewContainer, addImageButton, ImageType.LOGO);
                                });
                            previewContainer.empty();
                            previewContainer.append(imgPreview);
                            // addImageButton.val('');
                            ProgramUploader.logo = file;
                            // ProgramUploader.logoLastId += 1;
                        }
                    }

                    img.src = event.target.result;
                }

                reader.onerror = function (event) {
                    alert(event.target.error);
                }

                reader.onprogress = function (event) {
                    if (event.lengthComputable) {
                        const percentLoaded = Math.round((event.loaded / event.total) * 100);
                        console.log(percentLoaded);
                    }
                }

                reader.readAsDataURL(file);
            }
        }
        else if (imageType === ImageType.SCREENSHOTS) {
            previewContainer.empty();
            if (filesList !== ProgramUploader.screenshots) {
                for (let file of filesList) {
                    if (file.type.startsWith('image/')) {
                        ProgramUploader.screenshots.push(file);
                    }
                }
            }

            for (let id = 0; id < ProgramUploader.screenshots.length; id++) {
                let file = ProgramUploader.screenshots[id];
                let reader = new FileReader();

                // previewContainer.empty();

                reader.onload = function (event) {
                    let img = new Image();
                    img.onload = function () {
                        // id = ProgramUploader.screenshots.length;
                        let imgPreview = $(/*html*/`
                            <div class="image-preview-container" id="screenshot-preview-container-${id}" screenshot-id="${id}">
                                <img src="${event.target.result}" class="image-preview" id="screenshot-preview-${id}">
                                <div class="buttons-block">
                                    <button class="button edit-button edit"
                                            parent-id="screenshot-preview-container-${id}"
                                            id="change-screenshot-${id}-button"
                                            title="Заменить изображение">
                                    </button>
                                    <button class="button exit-button close-button"
                                            parent-id="screenshot-preview-container-${id}"
                                            id="remove-screenshot-${id}-button"
                                            title="Удалить изображение">
                                    </button>
                                </div>
                            </div>
                        `);
                        // changeImageTextFunc();
                        imgPreview
                            .find(`#change-screenshot-${id}-button`)
                            .on('click', function () {
                                addImageButton.click();
                                var screenshotId = $(this).closest('.image-preview-container').attr('screenshot-id');
                                ProgramUploader.removeImage(screenshotId, previewContainer, addImageButton, ImageType.SCREENSHOTS);
                            });

                        imgPreview
                            .find(`#remove-screenshot-${id}-button`)
                            .on('click', function () {
                                var screenshotId = $(this).closest('.image-preview-container').attr('screenshot-id');
                                // console.log(screenshotId);
                                ProgramUploader.removeImage(screenshotId, previewContainer, addImageButton, ImageType.SCREENSHOTS);
                            });

                        // previewContainer.empty();
                        addImageButton.val('');
                        previewContainer.append(imgPreview);
                    }

                    img.src = event.target.result;
                }
                reader.onerror = function (event) {
                    alert(event.target.error);
                }
                reader.onprogress = function (event) {
                    if (event.lengthComputable) {
                        const percentLoaded = Math.round((event.loaded / event.total) * 100);
                        console.log(percentLoaded);
                    }
                }

                reader.readAsDataURL(file);
            }
        }


        // for (let file of filesList) {
        //     if (file.type.startsWith('image/')) {
        //         let reader = new FileReader();

        //         reader.onload = function (event) {
        //             let imgPreview;

        //             if (imageType === ImageType.LOGO) {
        //                 let img = new Image();
        //                 img.onload = function () {
        //                     if (img.width !== img.height) {
        //                         // defaultImageTextFunc();
        //                         alert("Ширина и высота изображения для логотипа должны быть равны");
        //                         addImageButton.val(''); //очистка добавленных изображений
        //                     }
        //                     else {
        //                         id = ProgramUploader.logoLastId;
        //                         // changeImageTextFunc();
        //                         imgPreview = $(/*html*/`
        //                             <div class="image-preview-container" id="logo-preview-container-${id}" logo-id="${id}">
        //                                 <img src="${event.target.result}" class="image-preview">
        //                                 <div class="buttons-block">
        //                                     <button class="button edit-button edit"
        //                                             parent-id="logo-preview-container-${id}"
        //                                             title="Заменить изображение"
        //                                             id="change-logo-${id}-button"
        //                                             >
        //                                     </button>
        //                                     <button class="button exit-button close-button"
        //                                             parent-id="logo-preview-container-${id}"
        //                                             title="Удалить изображение"
        //                                             id="remove-logo-${id}-button"
        //                                             >
        //                                     </button>
        //                                 </div>
        //                             </div>
        //                         `);

        //                         imgPreview
        //                             .find(`#change-logo-${id}-button`)
        //                             .on('click', function () {
        //                                 ProgramUploader.logo = null;
        //                                 addImageButton.click();
        //                                 ProgramUploader.removeImage(id, previewContainer, addImageButton, ImageType.LOGO);
        //                             });

        //                         imgPreview
        //                             .find(`#remove-logo-${id}-button`)
        //                             .on('click', function () {
        //                                 ProgramUploader.logo = null;
        //                                 ProgramUploader.removeImage(id, previewContainer, addImageButton, ImageType.LOGO);
        //                             });
        //                         previewContainer.empty();
        //                         previewContainer.append(imgPreview);
        //                         addImageButton.val('');
        //                         ProgramUploader.logo = file;
        //                         ProgramUploader.logoLastId += 1;
        //                     }
        //                 }

        //                 img.src = event.target.result;
        //             }
        //             else if (imageType === ImageType.SCREENSHOTS) {

        //                 let img = new Image();
        //                 img.onload = function () {
        //                     id = ProgramUploader.screenshotLastId;
        //                     imgPreview = $(/*html*/`
        //                         <div class="image-preview-container" id="screenshot-preview-container-${id}" screenshot-id="${id}">
        //                             <img src="${event.target.result}" class="image-preview" id="screenshot-preview-${id}">
        //                             <div class="buttons-block">
        //                                 <!--<button class="button edit-button edit"
        //                                         parent-id="screenshot-preview-container-${id}"
        //                                         id="change-screenshot-${id}-button"
        //                                         title="Заменить изображение">
        //                                 </button> -->
        //                                 <button class="button exit-button close-button"
        //                                         parent-id="screenshot-preview-container-${id}"
        //                                         id="remove-screenshot-${id}-button"
        //                                         title="Удалить изображение">
        //                                 </button>
        //                             </div>
        //                         </div>
        //                     `);
        //                     // changeImageTextFunc();
        //                     // imgPreview
        //                     //     .find(`#change-screenshot-${id}-button`)
        //                     //     .on('click', function () {
        //                     //         addImageButton.click();
        //                     //         ProgramUploader.removeImage(id, previewContainer, addImageButton, ImageType.SCREENSHOTS);
        //                     //     });

        //                     imgPreview
        //                         .find(`#remove-screenshot-${id}-button`)
        //                         .on('click', function () {
        //                             var screenshotId = $(this).closest('.image-preview-container').attr('screenshot-id');
        //                             console.log(screenshotId);
        //                             ProgramUploader.removeImage(screenshotId, previewContainer, addImageButton, ImageType.SCREENSHOTS);
        //                         });

        //                     // previewContainer.empty();
        //                     addImageButton.val('');
        //                     previewContainer.append(imgPreview);
        //                     ProgramUploader.logo = file;
        //                     ProgramUploader.screenshotLastId += 1;
        //                     ProgramUploader.screenshots.push(file);
        //                 }

        //                 img.src = event.target.result;
        //             }

        //         }

        //         reader.onerror = function (event) {
        //             alert(event.target.error);
        //         }

        //         reader.onprogress = function (event) {
        //             // $("#add-logo-container span").html('Загрузка...');
        //             // loadingImageTextFunc();
        //             if (event.lengthComputable) {
        //                 const percentLoaded = Math.round((event.loaded / event.total) * 100);
        //                 console.log(percentLoaded);
        //             }
        //         }

        //         reader.readAsDataURL(file);

        //     }
        // }
    }


    static addImage(previewContainer, addImageButton, imageType) {// defaultImageTextFunc, changeImageTextFunc, loadingImageTextFunc, imageType) {
        const filesList = addImageButton.prop('files');
        ProgramUploader.addImagesFromArray(filesList, previewContainer, addImageButton, imageType);
        addImageButton.val('');
    }

    static uploadProgram() {

        let choosenCategories = getSelectedCategories()[0];
        let notChoosenCategories = getSelectedCategories()[1];


        //название программы
        let programName = $("#programName").val().trim();
        let nameIsGood = programName.length > 2;
        removeInputHighlight(
            $("#programName"),
            $("#programNameHint")
        );
        if (!nameIsGood) {
            highlightInputOnError(
                $("#programName"),
                $("#programNameHint"),
                "Название должно быть длинее двух символов"
            );
        }

        //краткое описание
        let shortDescription = $("#shortDescription").val().trim();
        let shortDescriptionIsGood =
            shortDescription.length > MIN_SHORT_DESCRIPTION_LENGTH &&
            shortDescription.length <= MAX_SHORT_DESCRIPTION_LENGTH;
        removeInputHighlight(
            $("#shortDescription"),
            $("#shortDescriptionHint")
        );
        if (!shortDescriptionIsGood) {
            highlightInputOnError(
                $("#shortDescription"),
                $("#shortDescriptionHint"),
                `Краткое описание должно быть от ${MIN_SHORT_DESCRIPTION_LENGTH} до ${MAX_SHORT_DESCRIPTION_LENGTH} символов`
            );
        }

        //полное описание
        let fullDescription = $("#fullDescription").val().trim();
        let fullDescriptionIsGood =
            fullDescription.length > MIN_FULL_DESCRIPTION_LENGTH &&
            fullDescription.length <= MAX_FULL_DESCRIPTION_LENGTH;
        removeInputHighlight(
            $("#fullDescription"),
            $("#fullDescriptionHint")
        )
        if (!fullDescriptionIsGood) {
            highlightInputOnError(
                $("#fullDescription"),
                $("#fullDescriptionHint"),
                `Полное описание должно быть от ${MIN_FULL_DESCRIPTION_LENGTH} до ${MAX_FULL_DESCRIPTION_LENGTH} символов`
            );
        }

        //категории
        removeInputHighlight(
            $(".category-select-row"),
            $(".category-select-row-hint")
        )
        let categoriesIsGood = choosenCategories.length >= MIN_CATEGORIES_AMOUNT
            && notChoosenCategories.length === 0;
        if (choosenCategories.length < MIN_CATEGORIES_AMOUNT) {
            highlightInputOnError(
                $("#categories-selects-box"),
                $("#categoriesSelectsHint"),
                `Выберите минимум ${MIN_CATEGORIES_AMOUNT} категорий`
            )
            $("#add-category-button").on('click', function () {
                removeInputHighlight(
                    $("#categories-selects-box"),
                    $("#categoriesSelectsHint")
                )
            });
        }
        if (notChoosenCategories.length > 0) {
            notChoosenCategories.forEach(idName => {
                highlightInputOnError(
                    $("#" + idName),
                    $("#" + idName + "-hint"),
                    `Выберите категорию и степень принадлежности к ней от ${MIN_DEGREE_OF_BELONGING} до ${MAX_DEGREE_OF_BELONGING}`
                )
            })
        }

        //стоимость
        let price =
            convertToNumber(
                $("#price").val(),
                {
                    "onError": () => highlightInputOnError($("#price"), $("#priceHint"), PRICE_MSG),
                    "onErrorResolved": () => removeInputHighlight($("#price"), $("#priceHint"))
                },
                MIN_PROGRAM_PRICE,
                MAX_PROGRAM_PRICE,
            );
        $("#price").val(price);

        //логотип
        let logo = ProgramUploader.logo;
        let screenshots = ProgramUploader.screenshots;
        // console.log(notChoosenCategories);

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
            "categories": choosenCategories,
            "logo": logo,
            "screenshots": screenshots
        }

        console.log(program)

        // var formData = new FormData();
        // for (let key in program) {
        //     if (program.hasOwnProperty(key)) {
        //         formData.append(key, program[key]);
        //     }
        // }
        // formData.append('logo', logo)

        // let response = JSON.stringify(program);
        // console.log(response);
        // }
        // else {
        //     alert(`Недопустимое действие. Ваша роль - "${USER.type}", а должна быть "Developer"`);
        // }
        // }

    }
}

function getSelectedCategories() {
    let categoriesRows = $(".categories-selects").find('.category-select-row');
    let choosenCategories = [];
    let notChoosenCategoriesIds = [];
    categoriesRows.each(function () {
        let categoryId = $(this).find('[name="category-select"]').val();
        let categoryName = $(this).find('[name="category-select"]').find('option:selected').text();
        let degreeOfBelonging = $(this).find('[name="category-degree-of-belonging"]').val();
        if (degreeOfBelonging > 10) degreeOfBelonging = 10;
        else if (degreeOfBelonging < 0) degreeOfBelonging = 0;

        if (categoryId === null || degreeOfBelonging === "") {
            notChoosenCategoriesIds.push($(this).attr('id'));
        }
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

    return [choosenCategories, notChoosenCategoriesIds];
}

function highlightInputOnError(inputJqueryItem, msgSpanJqueryItem, message = "") {
    inputJqueryItem.css({ "box-shadow": "inset 0 0 0 2px var(--red)" });
    msgSpanJqueryItem.css(ERROR_MESSAGE_STYLE_VISIBLE);
    if (message != "") {
        msgSpanJqueryItem.html(message);
    }
}

function removeInputHighlight(inputJqueryItem, msgSpanJqueryItem) {
    inputJqueryItem.css({ "box-shadow": "none" });
    msgSpanJqueryItem.css(ERROR_MESSAGE_STYLE_HIDDEN)
}

function limitTextInput(inputJquertItem, value, maxLength, hintJqueryItem) {
    removeInputHighlight(inputJquertItem, hintJqueryItem);
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


    // $("#add-logo-button").on('change', () => {
    $("#add-logo-button").on('change', () => {
        $("#add-logo-button").empty();
        ProgramUploader.addImage(
            $('#logo-preview-container'),
            $('#add-logo-button'),
            // function () {
            //     $("#add-logo-container span").html('Добавить логотип')
            // },
            // function () {
            //     $("#add-logo-container span").html('Заменить логотип')
            // },
            // function () {
            //     $("#add-logo-container span").html('Загрузка...')
            // },
            ImageType.LOGO
        );
    });

    $("#add-screenshots-button").on("change", () => {
        ProgramUploader.addImage(
            $('#screenshots-preview-container'),
            $('#add-screenshots-button'),
            // function () {
            //     $("#add-screenshots-container span").html('Добавить скриншоты')
            // },
            // function () {
            //     $("#add-screenshots-container span").html('Заменить скриншоты')
            // },
            // function () {
            //     $("#add-screenshots-container span").html('Загрузка...')
            // },
            ImageType.SCREENSHOTS
        )
    });

});


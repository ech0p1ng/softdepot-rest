var selectsForCategoriesCount = 0;

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
        let uploaderForm = $(/*html*/`
            <div id="pop-up-bg">
                <div id="pop-up-opened">
                    <div id="pop-up-header">
                        <span id="pop-up-title">Добавление программы</span>
                        <button id="pop-up-exit-button" class="exit-button button close-button" onclick="ProgramUploader.close()"></button>
                    </div>

                    <div class="pop-up-main">
                        <div>
                            <input type="text" class="input pop-up-one-line-input" name="programName" id="programName" placeholder="Название" title="Название">
                            <span type="text" class="msg-under-input" id="programNameHint"></span>
                        </div>
                        <div>
                            <textarea type="text" class="input pop-up-multi-line-input" name="shortDescription" id="shortDescription" placeholder="Краткое описание" title="Краткое описание"></textarea>
                            <span type="text" class="msg-under-input" id="shortDescriptionHint"></span>
                        </div>
                        <div>
                            <textarea type="text" class="input pop-up-multi-line-input" name="fullDescription" id="fullDescription" placeholder="Полное описание" title="Полное описание"></textarea>
                            <span type="text" class="msg-under-input" id="fullDescriptionHint"></span>
                        </div>
                        <div>
                            <input type="text" number-type="float" class="input pop-up-one-line-input" name="programPrice" id="price" placeholder="Стоимость (руб.)" title="Стоимость (руб.)">
                            <span type="text" class="msg-under-input" id="priceHint"></span>
                        </div>
                        <div>
                            <div id="categories-selects-box">
                                <div class="categories-selects"></div>
                                <button class="button pop-up-button full-width-button" id="add-category-button" style="margin-top: 10px;"><span>Добавить категорию</span></button>
                            </div>
                            <span type="text" class="msg-under-input" id="categoriesSelectsHint"></span>
                        </div>

                        <div>
                            <div>
                                <div class="preview-container" id="logo-preview-container" style="max-width: 33%;"></div>

                                <div class="file-input button pop-up-button full-width-button" id="add-logo-container">
                                    <input type="file" accept=${ACCEPTABLE_FILE_TYPES} id="add-logo-button" class="file-upload-button"></input>
                                    <span>Добавить логотип</span>
                                </div>
                            </div>
                            <span type="text" class="msg-under-input" id="logoHint"></span>
                        </div>

                        <div>
                            <div>
                                <div class="preview-container" id="screenshots-preview-container"></div>

                                <div class="file-input button pop-up-button full-width-button" id="add-screenshots-container">
                                    <input type="file" accept=${ACCEPTABLE_FILE_TYPES} id="add-screenshots-button" class="file-upload-button" multiple></input>
                                    <span>Добавить скриншоты</span>
                                </div>
                            </div>
                            <span type="text" class="msg-under-input" id="screenshotsHint"></span>
                        </div>
                    </div>

                    <div id="pop-up-footer">
                        <div style="height: 0px;"></div>
                        <div class="pop-up-footer-buttons">
                            <button class="button pop-up-button cancel-button">Отмена</button>
                            <button class="button pop-up-button ok-button" onclick="ProgramUploader.uploadProgram()">OK</button>
                        </div>
                    </div>
                </div>
            </div>
        `);


        uploaderForm.find("#add-category-button").on('click', () => ProgramUploader.addSelectRow());

        uploaderForm.find("#add-logo-button").on('change', (event) => {
            // uploaderForm.find("#add-logo-button").on('change', async (event) => {
            // const files = await waitForFiles(event.target);
            // alert("Логотип загружен:", files);

            uploaderForm.find("#add-logo-button").empty();
            ProgramUploader.addImage(
                uploaderForm.find('#logo-preview-container'),
                uploaderForm.find('#add-logo-button'),
                ImageType.LOGO
            );
        });

        uploaderForm.find("#add-screenshots-button").on("change", (event) => {
            // uploaderForm.find("#add-screenshots-button").on("change", async (event) => {
            //     const files = await waitForFiles(event.target);
            //     alert("Скриншоты загружены:", files);

            ProgramUploader.addImage(
                uploaderForm.find('#screenshots-preview-container'),
                uploaderForm.find('#add-screenshots-button'),
                ImageType.SCREENSHOTS
            )
        });

        uploaderForm.find("#price").on('input', function () {
            let result = convertToNumber(
                this.value,
                {
                    "onError": () => highlightInputOnError(
                        uploaderForm.find("#price"),
                        uploaderForm.find("#priceHint"),
                        PRICE_MSG
                    ),
                    "onErrorResolved": () => removeInputHighlight(
                        uploaderForm.find("#price"),
                        uploaderForm.find("#priceHint")
                    )
                },
                MIN_PROGRAM_PRICE,
                MAX_PROGRAM_PRICE,
            );
            this.value = result;
        });

        uploaderForm.find("#programName").on('input', function () {
            this.value = limitTextInput(
                $(this),
                this.value,
                MAX_RROGRAM_NAME_LENGTH,
                uploaderForm.find("#programNameHint")
            );
        });

        uploaderForm.find("#shortDescription").on('input', function () {
            this.value = limitTextInput(
                $(this),
                this.value,
                MAX_SHORT_DESCRIPTION_LENGTH,
                uploaderForm.find("#shortDescriptionHint")
            );
        });

        uploaderForm.find("#fullDescription").on('input', function () {
            this.value = limitTextInput(
                $(this),
                this.value,
                MAX_FULL_DESCRIPTION_LENGTH,
                uploaderForm.find("#fullDescriptionHint")
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
            complete: () => {
                $('body').append(uploaderForm);
            }
        });
    }

    static close() { $("#pop-up-bg").remove(); }

    static addSelectRow(scroll = true) {
        let selectRow = $(/*html*/`
            <div id="category-selector-${selectsForCategoriesCount}">
                <div class="category-select-row" id="category-select-row-${selectsForCategoriesCount}">
                    <select class="select pop-up-select-input" name="category-select" title="Выберите категорию">
                        <option value="" class="select-option" disabled selected>Выберите категорию...</option>
                    </select>
                    <input id="category-degree-of-belonging-${selectsForCategoriesCount}" class="input pop-up-one-line-input only-int-input" type="number" placeholder="Степень принадлежности (от ${MIN_DEGREE_OF_BELONGING} до ${MAX_DEGREE_OF_BELONGING})" title="Степень принадлежности программы к категории (число от ${MIN_DEGREE_OF_BELONGING} до ${MAX_DEGREE_OF_BELONGING})" min="${MIN_DEGREE_OF_BELONGING}" max="${MAX_DEGREE_OF_BELONGING}" step="1" name="category-degree-of-belonging">
                    <button class="button exit-button close-button remove-button" id="remove-category-button-${selectsForCategoriesCount}" title="Удалить категорию" row-id="${selectsForCategoriesCount}" onclick="ProgramUploader.deleteSelectRow(${selectsForCategoriesCount})"></button>
                </div>
                <span type="text" class="msg-under-input category-select-row-hint" id="category-select-row-${selectsForCategoriesCount}-hint"></span>
            </div>
        `);

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
        previewContainer.empty();
        if (imageType === ImageType.LOGO) {
            ProgramUploader.logo = null;
        }
        else if (imageType === ImageType.SCREENSHOTS) {
            ProgramUploader.screenshots.splice(id, 1);
            ProgramUploader.addImagesFromArray(
                ProgramUploader.screenshots,
                previewContainer,
                addImageButton,
                imageType
            )
        }
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
                        id = ProgramUploader.logoLastId;
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
                        ProgramUploader.logo = file;
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

                reader.onload = function (event) {
                    let img = new Image();
                    img.onload = function () {
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
                                ProgramUploader.removeImage(screenshotId, previewContainer, addImageButton, ImageType.SCREENSHOTS);
                            });

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
    }


    static addImage(previewContainer, addImageButton, imageType) {
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
        let shortDescription = $("#shortDescription").val()
            .trim()
            .replace("\n", "\\n")
            .replace("\t", "\\t");
        let shortDescriptionIsGood =
            shortDescription.length >= MIN_SHORT_DESCRIPTION_LENGTH &&
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
        let fullDescription = $("#fullDescription").val()
            .trim()
            .replace("\n", "\\n")
            .replace("\t", "\\t");

        let fullDescriptionIsGood =
            fullDescription.length >= MIN_FULL_DESCRIPTION_LENGTH &&
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
            );
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

        let logoIsGood = logo !== null;

        if (!logoIsGood) {
            highlightInputOnError(
                $("#add-logo-container"),
                $("#logoHint"),
                `Выберите логотип`
            );
        }

        let screenshots = ProgramUploader.screenshots;

        let screenshotsIsGood = !screenshots.empty && screenshots.length >= MIN_SCREENSHOTS_AMOUNT;
        if (!screenshotsIsGood) {
            highlightInputOnError(
                $("#add-screenshots-container"),
                $("#screenshotsHint"),
                `Выберите минимум ${MIN_SCREENSHOTS_AMOUNT} скриншотов`
            );
        }



        if (USER == null) {
            alert("Авторизируйтесь!")
        }
        else {
            if (USER.type === "Developer") {
                if (nameIsGood && shortDescriptionIsGood && fullDescriptionIsGood &&
                    categoriesIsGood && logoIsGood && screenshotsIsGood) {
                    const formData = new FormData();
                    formData.append("developerId", USER.id);
                    formData.append("name", programName);
                    formData.append("shortDescription", shortDescription);
                    formData.append("fullDescription", fullDescription);
                    formData.append("price", price);
                    formData.append("categories", JSON.stringify(choosenCategories));
                    formData.append("logo", logo);

                    for (let i = 0; i < screenshots.length; i++) {
                        formData.append("screenshots", screenshots[i]);
                    }

                    $.ajax({
                        method: "POST",
                        url: BACKEND_URL + "softdepot-api/products/new",
                        processData: false,
                        contentType: false,
                        data: formData,
                        success: (response) => {
                            let program = new Program(response);
                            window.location.href = program.pageUrl;
                        },
                        error: (xhr, status, message) => {
                            console.error(xhr.responseJSON.message);
                            alert("Не удалось добавить программу в каталог.\n" + xhr.responseJSON.message);
                        }
                    });
                }
            }
            else {
                alert("Вы должны быть авторизованы как разработчик");
            }
        }
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
        let category = {
            "id": categoryId,
            "name": categoryName,
            "degreeOfBelonging": degreeOfBelonging,
            "programId": null
        };
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
        highlightInputOnError(
            inputJquertItem,
            hintJqueryItem,
            value.length + "/" + maxLength
        )
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

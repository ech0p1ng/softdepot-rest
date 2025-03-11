const MIN_CATEGORY_NAME_LENGTH = 3;
const MAX_CATEGORY_NAME_LENGTH = 25;
const CATEGORY_NAME_LENGTH_MESSAGE = `Название категории должно быть от ${MIN_CATEGORY_NAME_LENGTH} до ${MAX_CATEGORY_NAME_LENGTH} символов`;

class Tag {
    static getEmptyEditorItem(onSuccess) {
        let emptyCategoryEditor = $(/*html*/`
            <div class="category-editor-item" id="empty-category-item">
                <div class="category-editor-item-wrapper">
                    <input type="text" class="input category-name-input" placeholder="Название категории" title="Название категории">
                    <button class="button save-button category-change-button" title="Редактировать"></button>
                    <button class="button close-button remove-button" title="Удалить"></button>
                </div>
                <span type="text" class="msg-under-input" id="categoryHint">Текст ошибки</span>
            </div>
        `);

        emptyCategoryEditor.find(".category-name-input").on('input', function () {
            removeInputHighlight(
                $(this),
                $(this).closest(".category-editor-item").find("#categoryHint")
            )
            this.value = limitTextInput(
                $(this),
                this.value,
                MAX_CATEGORY_NAME_LENGTH,
                $(this).closest(".category-editor-item").find("#categoryHint")
            )
        })

        emptyCategoryEditor.find(".save-button").on('click', () => {
            let name = emptyCategoryEditor.find(".category-name-input").val();
            if (name.length < MIN_CATEGORY_NAME_LENGTH || name.length > MAX_CATEGORY_NAME_LENGTH) {
                highlightInputOnError(
                    emptyCategoryEditor.find(".category-name-input"),
                    emptyCategoryEditor.find("#categoryHint"),
                    CATEGORY_NAME_LENGTH_MESSAGE
                )
            }
            else {
                $.ajax({
                    method: "POST",
                    url: BACKEND_URL + "softdepot-api/categories/new",
                    contentType: "application/json",
                    data: JSON.stringify(
                        new Tag({
                            id: 0,
                            name: name,
                            degreeOfBelonging: 0,
                            programId: 0
                        })
                    ),
                    success: (response) => {
                        emptyCategoryEditor.remove();
                        let newTag = new Tag(response);
                        onSuccess(newTag.editorItem);
                    },
                    error: (xhr, status, message) => {
                        alert(xhr.responseJSON.message);
                    }
                });
            }
        });

        emptyCategoryEditor.find(".remove-button").on('click', () => emptyCategoryEditor.remove());
        return emptyCategoryEditor;
    }

    constructor(data) {
        this.id = data.id;
        this.name = data.name;
        this.degreeOfBelonging = data.degreeOfBelonging;
        this.programId = data.programId;

        this.editorItem = $(/*html*/`
            <div class="category-editor-item" category-id="${this.id}">
                <div class="category-editor-item-wrapper">
                    <input type="text" class="input category-name-input" placeholder="Название категории" title="Название категории" value="${this.name}">
                    <button class="button close-button remove-button" title="Удалить"></button>
                </div>
                <span type="text" class="msg-under-input" id="categoryHint">Текст ошибки</span>
            </div>
        `);

        this.editorItem.find(".category-name-input").on('input', (event) => {
            if (this.editorItem.find(".save-button").length === 0) {
                let saveButton = $(/*html*/`
                    <button class="button save-button category-change-button" title="Редактировать"></button>
                `);
                saveButton.on('click', () => {
                    this.name = this.editorItem.find(".category-name-input").val();
                    if (this.name.length < MIN_CATEGORY_NAME_LENGTH || this.name.length > MAX_CATEGORY_NAME_LENGTH) {
                        highlightInputOnError(
                            this.editorItem.find(".category-name-input"),
                            this.editorItem.find("#categoryHint"),
                            CATEGORY_NAME_LENGTH_MESSAGE
                        )
                    }
                    else {
                        $.ajax({
                            url: BACKEND_URL + "softdepot-api/categories/" + this.id,
                            method: 'PATCH',
                            contentType: 'application/json',
                            data: JSON.stringify({
                                "id": this.id,
                                "name": this.name,
                                "degreeOfBelonging": 0,
                                "programId": 0
                            }),
                            success: (response) => {
                                this.editorItem.find("#categoryHint").css(HINT_MESSAGE_STYLE_HIDDEN);
                                this.editorItem.find(".category-change-button").remove();
                            },
                            error: (xhr, status, error) => {
                            }
                        });
                    }
                });

                saveButton.insertBefore(this.editorItem.find(".remove-button"));
            }

            removeInputHighlight(
                this.editorItem.find(".category-name-input"),
                this.editorItem.find("#categoryHint")
            )
            event.target.value = limitTextInput(
                this.editorItem.find(".category-name-input"),
                event.target.value,
                MAX_CATEGORY_NAME_LENGTH,
                this.editorItem.find("#categoryHint")
            )
        })

        this.editorItem.find(".remove-button").on('click', () => {
            this.name = this.editorItem.find(".category-name-input").val();
            $.ajax({
                url: BACKEND_URL + "softdepot-api/categories/" + this.id,
                method: 'DELETE',
                contentType: 'application/json',
                data: null,
                success: (response) => {
                    this.editorItem.remove();
                },
                error: (xhr, status, error) => {
                }
            });
        });
    }
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
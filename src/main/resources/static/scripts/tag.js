const MIN_CATEGORY_NAME_LENGTH = 3;
const MAX_CATEGORY_NAME_LENGTH = 25;

class Tag {
    static emptyCategoryEditor = $(/*html*/`
        <div class="category-editor-item" id="empty-category-item">
            <div class="category-editor-item-wrapper">
                <input type="text" class="input category-name-input" placeholder="Название категории" title="Название категории">
                <button class="button save-button category-change-button" title="Редактировать"></button>
                <button class="button close-button remove-button" title="Удалить"></button>
            </div>
            <span type="text" class="msg-under-input" id="categoryHint">Текст ошибки</span>
        </div>
    `);

    constructor(data) {
        this.id = data.id;
        this.name = data.name;
        this.degreeOfBelonging = data.degreeOfBelonging;
        this.programId = data.programId;

        this.editorItem = $(/*html*/`
            <div class="category-editor-item" category-id="${this.id}">
                <div class="category-editor-item-wrapper">
                    <input type="text" class="input category-name-input" placeholder="Название категории" title="Название категории" value="${this.name}">
                    <button class="button save-button category-change-button" title="Редактировать"></button>
                    <button class="button close-button remove-button" title="Удалить"></button>
                </div>
                <span type="text" class="msg-under-input" id="categoryHint">Текст ошибки</span>
            </div>
        `);

        this.editorItem.find(".category-change-button").on('click', () => {
            this.name = this.editorItem.find(".category-name-input").val();
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
                success: function (response) {
                },
                error: function (xhr, status, error) {
                }
            });
        });


        this.editorItem.find(".remove-button").on('click', () => {
            this.name = this.editorItem.find(".category-name-input").val();
            $.ajax({
                url: BACKEND_URL + "softdepot-api/categories/" + this.id,
                method: 'DELETE',
                contentType: 'application/json',
                data: null,
                success: (response) => {
                    this.editorItem.remove();
                    // console.log('Ресурс успешно обновлен:', response);
                },
                error: (xhr, status, error) => {
                    // console.error('Ошибка при обновлении ресурса:', error);
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
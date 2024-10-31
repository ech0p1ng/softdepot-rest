function get_tag_row(tag_name, tag_id) {
    return ''+
        '<div class="category-row" tag-id="'+tag_id+'">'+
        '    <input type="text" class="category-name" tag-id="'+tag_id+'" value="'+tag_name+'" placeholder="Название категории"/>'+
        '    <div class="category-row-buttons">'+
        '        <button class="button save-button" tag-id="'+tag_id+'" onClick="save_tag(event)"></button>'+
        '        <button class="button delete-button" tag-id="'+tag_id+'" onClick="delete_tag(event)"></button>'+
        '    </div>'+
        '</div>';
}

function get_tags() {
    return new Promise((resolve, reject) => {
        $.ajax({
            type: "GET",
            url: "/tag/get-all",
            contentType: "application/json; charset=utf-8",
            success: function (tags) {
                tags.forEach(function (tag){
                    add_tag_row(tag.name, tag.id);
                })
                resolve();
            },
            error: function () {reject();}
        })
    });
}

function save_tag(event) {
    let tag_id = event.currentTarget.getAttribute("tag-id");
    let tag_name = $('.category-name[tag-id="'+tag_id+'"]').val();
    console.log(tag_id);
    console.log(tag_name);

    let data = {
        id: tag_id,
        name: tag_name
    };
    $.ajax({
        type: 'POST',
        url: '/tag/save-tag',
        data: JSON.stringify(data),
        contentType: "application/json; charset=utf-8",
        success: function (response) {
            console.log(response);
            update_tags();
        },
        error: function (response) {
            console.log(response);
            update_tags();
        }
    });
}

function delete_tag(event) {
    let tag_id = event.currentTarget.getAttribute("tag-id");
    let tag_name = $('.category-name[tag-id="'+tag_id+'"]').val();
    console.log(tag_id);
    console.log(tag_name);

    let result = false;
    if (tag_name === "") result = true;
    else result = confirm('Вы действительно хотите удалить категорию "'+ tag_name+'"?');

    if (result) {
        let data = {
            id: tag_id,
            name: tag_name
        };

        $.ajax({
            type: 'POST',
            url: '/tag/delete-tag/id' + tag_id,
            data: JSON.stringify(data),
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                console.log(response);
                update_tags();
            },
            error: function (response) {
                console.log(response);
                update_tags();
            }
        });
    }
}

function add_tag_row(tag_name, tag_id) {
    let category_row = get_tag_row(tag_name, tag_id);
    $('.tags-rows').prepend(category_row);

}

function update_tags() {
    $('.tags-rows').empty();

    get_tags()
        .then(tags =>{
            tags.forEach(function (tag){
                add_tag_row(tag.name, tag.id);
            })
        })
        .catch(error => {
            console.log(error);
        })

}

document.addEventListener("DOMContentLoaded", function () {
    update_tags();
})
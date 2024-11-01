function registration() {
    let data = {
        name: $("#username").val(),
        email: $("#email").val(),
        password: $("#password").val(),
        userType: $('input[name="userType"]:checked').val()
    }

    $.ajax({
        method: "POST",
        url: "http://127.0.0.1:8080/softdepot-api/users/new",
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (response) {
            alert("Успех\n\n" + response);
        },
        error: function (xhr, status, error) {
            // let errorResponse = new ErrorResponse(error);
            // alert("Ошибка\n\n" + error.toString());
            // console.error(JSON.parse(error));
            if (xhr.responseJSON) {
                $(".error-messages").html('');
                var errorResponse = xhr.responseJSON;

                //Ошибки валидации
                if (errorResponse.errors) {
                    let messages = [];
                    errorResponse.errors.forEach((error) => {
                        // printErrorMessage(error.defaultMessage);
                        messages.push(error.defaultMessage);
                    });
                    messages.sort();
                    messages.forEach((message) => {
                        printErrorMessage(message);
                    });
                }
                //другие ошибки сервера
                else
                    printErrorMessage(errorResponse.message);


            } else {
                console.error('Ошибка:', error);
            }
        }
    });

}

function printErrorMessage(message) {
    console.error(message);
    var arr = message.split("\n");
    arr.forEach((msg) => {
        $(".error-messages").append('<span style="color: red" class="error-message">' + msg + '</span> <br/>');
    });

}
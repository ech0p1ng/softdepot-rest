function registration() {
    let data = {
        name: $("#username").val(),
        email: $("#email").val(),
        password: $("#password").val(),
        userType: $('input[name="userType"]:checked').val()
    }

    sendRequest("http://127.0.0.1:8080/softdepot-api/users/new", data);
}

function signIn() {
    let data = {
        email: $("#email").val(),
        password: $("#password").val(),
    }

    sendRequest("http://127.0.0.1:8080/softdepot-api/users/sign-in", data);
}

function sendRequest(url, data) {
    $.ajax({
        method: "POST",
        url: url,
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (response) {
            // alert("Успех\n\n" + response);
        },
        error: function (xhr, status, error) {
            if (xhr.responseJSON) {
                $(".error-messages").html('');
                let errorResponse = xhr.responseJSON;

                //Ошибки валидации
                if (errorResponse.errors) {
                    let messages = [];
                    errorResponse.errors.forEach((error) => {
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
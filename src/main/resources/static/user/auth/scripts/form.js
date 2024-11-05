function registration() {
    var data = {
        name: $("#username").val(),
        email: $("#email").val(),
        password: $("#password").val(),
        userType: $('input[name="userType"]:checked').val()
    }

    sendRequest("http://127.0.0.1:8080/softdepot-api/users/new", data);
}

function signIn() {
    var data = {
        email: $("#email").val(),
        password: $("#password").val(),
    }

    var response = sendRequest(
        "http://127.0.0.1:8080/softdepot-api/users/sign-in",
        data
    );
}

function sendRequest(url, data) {
    $.ajax({
        method: "POST",
        url: url,
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (response) {
            $(".error-messages").html('');
            return response;
        },
        error: function (xhr, status, error) {
            $(".error-messages").html('');
            if (xhr.responseJSON) {
                var errorResponse = xhr.responseJSON;

                //Ошибки валидации
                if (errorResponse.errors) {
                    var messages = [];
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
                console.error(error);
            }
        }
    });
    return null;
}

function printErrorMessage(message) {
    var arr = message.split("\n");
    arr.forEach((msg) => {
        console.error(msg);
        $(".error-messages").append(
            '<span style="color: red" class="error-message">' + msg + '</span> <br/>'
        );
    });

}
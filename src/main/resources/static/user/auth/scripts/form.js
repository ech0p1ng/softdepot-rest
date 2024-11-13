function registration() {
    var data = {
        userName: $("#username").val(),
        // email: $("#email").val(),
        password: $("#password").val(),
        userType: $('input[name="userType"]:checked').val()
    }

    $.ajax({
        method: "POST",
        url: "http://127.0.0.1:8080/softdepot-api/users/new",
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (response) {
            $(".error-messages").html('');
            window.location.href = "/sign-in";
            return response;
        },
        error: errorResponse
    });

}

function signIn() {
    var data = {
        userName: $("#username").val(),
        password: $("#password").val(),
    }

    $.ajax({
        method: "POST",
        url: "http://127.0.0.1:8080/softdepot-api/users/sign-in",
        contentType: 'application/json',
        data: JSON.stringify(data),
        credentials: "include",
        success: function (response) {
            $(".error-messages").html('');
            window.location.href = "/";
            return response;
        },
        error: errorResponse
    });
}

function errorResponse(xhr, status, error) {
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

window.onload = () => {
    setTheme();
}
function submitForm() {
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
            alert(response);
        },
        error: function (error) {
            alert(error);
        }
    });

}
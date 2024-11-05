package ru.softdepot.requestBodies;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

@Data
public class SignInRequestBody {
    @Email(message = "Некорректный email")
    @NotBlank(message = "Введите email")
    String email;

    @NotBlank(message = "Введите пароль")
    @Length(min = 8, max = 30, message = "Пароль должен быть длиной от 8 до 30 символов")
    String password;

    public SignInRequestBody(String email, String password) {
        this.email = email;
        this.password = password;
    }
}

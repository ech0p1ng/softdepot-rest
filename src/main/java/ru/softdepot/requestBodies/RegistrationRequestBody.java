package ru.softdepot.requestBodies;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import ru.softdepot.core.models.User;

@Data
public class RegistrationRequestBody {
    @NotBlank(message = "Введите имя пользователя")
    String userName;

    @NotBlank(message = "Введите пароль")
    @Length(min = 8, max = 30, message = "Пароль должен быть длиной от 8 до 30 символов")
    String password;

    @NotNull(message = "Выберите роль")
    User.Type userType;

    public RegistrationRequestBody(String userName, String password, User.Type userType) {
        this.userName = userName;
        this.password = password;
        this.userType = userType;
    }

    public String getName() {
        return userName;
    }

    public void setName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public User.Type getUserType() {
        return userType;
    }

    public void setUserType(User.Type userType) {
        this.userType = userType;
    }
}

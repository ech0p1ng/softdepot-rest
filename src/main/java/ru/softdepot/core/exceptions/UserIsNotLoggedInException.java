package ru.softdepot.core.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;


@ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "My reason")
public class UserIsNotLoggedInException extends RuntimeException {
    public UserIsNotLoggedInException(String message) {
        super(message);
    }
}

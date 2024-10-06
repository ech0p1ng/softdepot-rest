package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.Messages.Message;
import ru.softdepot.core.dao.UserDAO;
import ru.softdepot.core.models.User;

@RestController
@RequestMapping("softdepot-api/users")
@AllArgsConstructor
public class UsersController {
    private final UserDAO userDAO;

    @PostMapping("/new")
    public ResponseEntity<?> newUser(@RequestBody User user,
                                     BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (userDAO.exists(user.getEmail()))
                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .body(Message.build(
                                Message.Entity.user,
                                Message.Identifier.email,
                                user.getEmail(),
                                Message.Status.alreadyExists
                        ));

            userDAO.add(user);
            return ResponseEntity.ok().build();
        }
    }
}

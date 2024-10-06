package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
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
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.USER,
                                Message.Identifier.EMAIL,
                                user.getEmail(),
                                Message.Status.ALREADY_EXISTS
                        )
                );

            userDAO.add(user);
            return ResponseEntity.ok().build();
        }
    }
}

package ru.softdepot.controllers;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.messages.Message;
import ru.softdepot.core.dao.UserDAO;
import ru.softdepot.core.models.User;
import ru.softdepot.requestBodies.SignInRequestBody;

@RestController
@RequestMapping("softdepot-api/users")
@AllArgsConstructor
public class UsersController {
    private final UserDAO userDAO;

    @PostMapping("/new")
    public ResponseEntity<?> newUser(@Valid @RequestBody User user,
                                     BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            StringBuilder message = new StringBuilder();

            if (userDAO.existsByEmail(user.getEmail())) {
                message.append(
                        Message.build(
                                Message.Entity.USER,
                                Message.Identifier.EMAIL,
                                user.getEmail(),
                                Message.Status.ALREADY_EXISTS
                        ));
            }

            if (userDAO.existsByName(user.getName())) {
                if (!message.isEmpty()) message.append("\n");
                message.append(
                        Message.build(
                                Message.Entity.USER,
                                Message.Identifier.NAME,
                                user.getName(),
                                Message.Status.ALREADY_EXISTS
                        ));
            }

            if (!message.isEmpty()) {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        message.toString()
                );
            }

            userDAO.add(user);
            return ResponseEntity.ok().build();
        }
    }

    @PostMapping("/sign-in")
    public ResponseEntity<?> signIn(@Valid @RequestBody SignInRequestBody signInRequestBody,
                                    BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
//            StringBuilder message = new StringBuilder();

//            if (!userDAO.existsByEmail(user.getEmail())) {
//                message.append(
//                        Message.build(
//                                Message.Entity.USER,
//                                Message.Identifier.EMAIL,
//                                user.getEmail(),
//                                Message.Status.NOT_FOUND
//                        ));
//            }

//            if (!message.isEmpty()) {
//                throw new ResponseStatusException(
//                        HttpStatus.CONFLICT,
//                        message.toString()
//                );
//            }

            var user = userDAO.getByEmailAndPassword(
                    signInRequestBody.getEmail(),
                    signInRequestBody.getPassword()
            );

            if (user == null) {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        "Неверный email или пароль"
                );
            }

            return ResponseEntity.ok().body(user);
        }
    }
}

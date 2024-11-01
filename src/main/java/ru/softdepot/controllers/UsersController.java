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
            System.out.println(user.getName());
            System.out.println(user.getEmail());
            System.out.println(user.getPassword());
            System.out.println(user.getUserType());

            StringBuilder message = new StringBuilder();

//            if (userDAO.existsByEmail(user.getEmail()))
//                throw new ResponseStatusException(
//                        HttpStatus.CONFLICT,
//                        Message.build(
//                                Message.Entity.USER,
//                                Message.Identifier.EMAIL,
//                                user.getEmail(),
//                                Message.Status.ALREADY_EXISTS
//                        )
//                );

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

//            if (userDAO.existsByName(user.getName()))
//                throw new ResponseStatusException(
//                        HttpStatus.CONFLICT,
//                        Message.build(
//                                Message.Entity.USER,
//                                Message.Identifier.NAME,
//                                user.getName(),
//                                Message.Status.ALREADY_EXISTS
//                        )
//                );

            userDAO.add(user);
            return ResponseEntity.ok().build();
        }
    }
}

package ru.softdepot.controllers;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.config.SecurityConfig;
import ru.softdepot.messages.Message;
import ru.softdepot.core.dao.UserDAO;
import ru.softdepot.core.models.User;
import ru.softdepot.requestBodies.SignInRequestBody;

@RestController
@RequestMapping("softdepot-api/users")
@AllArgsConstructor
public class UsersController {
    private final UserDAO userDAO;
    private final AuthenticationManager authenticationManager;
    private final PasswordEncoder passwordEncoder;

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

            user.setPassword(passwordEncoder.encode(user.getPassword()));
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
            try {

//                var user = userDAO.getByEmailAndPassword(
//                        signInRequestBody.getEmail(),
//                        signInRequestBody.getPassword()
//                );


                var userToken = new UsernamePasswordAuthenticationToken(
                        signInRequestBody.getEmail(),
                        signInRequestBody.getPassword()
                );


                authenticationManager.authenticate(userToken);

                return ResponseEntity.ok().build();
            } catch (Exception e) {
                e.printStackTrace();
                throw new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Неверный email или пароль"
                );
            }
        }
    }
}

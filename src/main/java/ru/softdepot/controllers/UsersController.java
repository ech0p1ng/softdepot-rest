package ru.softdepot.controllers;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.config.JwtTokenProvider;
import ru.softdepot.config.MyUserDetails;
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
    private final JwtTokenProvider jwtTokenProvider;

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
                Authentication authentication = authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken(
                                signInRequestBody.getEmail(),
                                signInRequestBody.getPassword()
                        )
                );

                SecurityContextHolder.getContext().setAuthentication(authentication);

                String token = jwtTokenProvider.generateToken(authentication);

                return ResponseEntity.ok().header("Authorization-Token", token).body(token);
            } catch (Exception e) {
                e.printStackTrace();
                throw new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Неверный email или пароль"
                );
            }
        }
    }

    @GetMapping()
    public ResponseEntity<?> getUserByToken(@RequestParam("token") String token) throws Exception {
        var email = jwtTokenProvider.getUsername(token);
        var userDetails = (MyUserDetails) userDAO.loadUserByUsername(email);
        return ResponseEntity.ok().body(userDetails.getUser());
    }
}

package ru.softdepot.controllers;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
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
import ru.softdepot.core.dao.UserDAO;
import ru.softdepot.core.models.User;
import ru.softdepot.messages.Message;
import ru.softdepot.requestBodies.RegistrationRequestBody;
import ru.softdepot.requestBodies.SignInRequestBody;

@RestController
@RequestMapping("softdepot-api/users")
@AllArgsConstructor
public class UsersController {
    private UserDAO userDAO;
    private AuthenticationManager authenticationManager;
    private PasswordEncoder passwordEncoder;
    private JwtTokenProvider jwtTokenProvider;

    public static User getCurrentUser(UserDAO userDAO) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            var userAuth = (org.springframework.security.core.userdetails.User) authentication.getPrincipal();
            return userDAO.getByUserName(userAuth.getUsername());
        }
        return null;
    }

    @PostMapping("/new")
    public ResponseEntity<?> newUser(@Valid @RequestBody RegistrationRequestBody body,
                                     BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (userDAO.existsByName(body.getName())) {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.USER,
                                Message.Identifier.NAME,
                                body.getName(),
                                Message.Status.ALREADY_EXISTS
                        )
                );
            }

            User user = new User(
                    body.getName(),
                    null,
                    body.getUserType()
            );

            user.setPassword(passwordEncoder.encode(body.getPassword()));
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
                                signInRequestBody.getUserName(),
                                signInRequestBody.getPassword()
                        )
                );

                SecurityContextHolder.getContext().setAuthentication(authentication);

                String token = jwtTokenProvider.generateToken(authentication);

                // Создание HttpOnly Cookie
                ResponseCookie jwtCookie = ResponseCookie.from("JWT-TOKEN", token)
                        .httpOnly(true)
                        .secure(false) //HTTPS h
                        .path("/")
                        .sameSite("Strict")
                        .maxAge(60 * 60 * 24 * 7) // Срок жизни cookie (в секундах)
                        .build();

                return ResponseEntity.ok()
                        .header(HttpHeaders.SET_COOKIE,
                                jwtCookie.toString())
                        .build();
            } catch (Exception e) {
                e.printStackTrace();
                throw new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Неверное имя пользователя или пароль"
                );
            }
        }
    }

    @PostMapping("/sign-out")
    public ResponseEntity<?> signOut() {
        ResponseCookie deleteCookie = ResponseCookie.from("JWT-TOKEN", "")
                .httpOnly(true)
                .secure(true)
                .path("/")
                .maxAge(0) // Нулевой срок жизни удаляет cookie
                .build();
        System.out.println("logout");
        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, deleteCookie.toString())
                .build();
    }

    @GetMapping("/current")
    public ResponseEntity<?> getUserByToken() throws Exception {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            var userAuth = (org.springframework.security.core.userdetails.User) authentication.getPrincipal();
            var user = userDAO.getByUserName(userAuth.getUsername());
            return ResponseEntity.ok().body(user);
        } else {
            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED,
                    "Вы не авторизованы"
            );
        }
    }
}

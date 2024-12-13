package ru.softdepot.controllers;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import ru.softdepot.config.MyUserDetails;
import ru.softdepot.core.models.User;

@Controller
public class HtmlPagesController {
    @GetMapping
    public String mainPage() {
        return "/mainpage/index.html";
    }

    @GetMapping("/programs/{programId}")
    public String programPage(@PathVariable("programId") String programId) {
        return "/program/index.html";
    }

    @GetMapping("/registration")
    public String registrationPage() {
        return "/user/auth/registration/index.html";
    }

    @GetMapping("/porno")
    public String pornoPage() {
        return "redirect:https://www.youtube.com/watch?v=dQw4w9WgXcQ&pp=ygUXbmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXA%3D";
    }

    @GetMapping("/sign-in")
    public String signInPage() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            MyUserDetails userDetails = (MyUserDetails) authentication.getPrincipal();
            User user = userDetails.getUser();
            return "reditect:/";
        }

        return "/user/auth/sign_in/index.html";
    }

    @GetMapping("/developers/{developerId}")
    public String developerPage(@PathVariable("developerId") String developerId) {
        return "/user/dev/index.html";
    }
}

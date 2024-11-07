package ru.softdepot.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

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
        return "/user/registration/index.html";
    }

    @GetMapping("/porno")
    public String pornoPage() {
        return "redirect:https://www.youtube.com/watch?v=dQw4w9WgXcQ&pp=ygUXbmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXA%3D";
    }

    @GetMapping("/sign-in")
    public String signInPage() {
        return "/user/sign_in/index.html";
    }
}

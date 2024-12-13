package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import ru.softdepot.config.MyUserDetails;
import ru.softdepot.core.dao.CustomerDAO;
import ru.softdepot.core.dao.DeveloperDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.User;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
public class HtmlPagesController {
    private static ProgramDAO programDAO = new ProgramDAO();
    private static DeveloperDAO developerDAO = new DeveloperDAO();
    private static CustomerDAO customerDAO = new CustomerDAO();


    @GetMapping
    public String mainPage() {
        return "/mainpage/index.html";
    }

    @GetMapping("/programs/{programId}")
    public String programPage(@PathVariable("programId") String programId) {
        int id;
        try {
            id = Integer.parseInt(programId);
        } catch (Exception e) {
            return "redirect:/";
        }

        if (programDAO.exists(id))
            return "/program/index.html";
        else {
            return "redirect:/";
        }
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
        int id;
        try {
            id = Integer.parseInt(developerId);
        } catch (Exception e) {
            return "redirect:/";
        }

        if (developerDAO.exists(id)) {
            return "/user/dev/index.html";
        } else {
            return "redirect:/";
        }
    }
}

package ru.softdepot.controllers;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import ru.softdepot.config.MyUserDetails;
import ru.softdepot.core.dao.AdministratorDAO;
import ru.softdepot.core.dao.CustomerDAO;
import ru.softdepot.core.dao.DeveloperDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.User;

@Controller
public class HtmlPagesController {
    private static ProgramDAO programDAO = new ProgramDAO();
    private static DeveloperDAO developerDAO = new DeveloperDAO();
    private static CustomerDAO customerDAO = new CustomerDAO();
    private static AdministratorDAO administratorDAO = new AdministratorDAO();


//    @GetMapping()
//    public String mainPage() {
//        return "/mainpage/index.html";
//    }

    @GetMapping("/")
    public String mainPage2() {
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

    //Страницы пользователей
    @GetMapping("/{usersRole}/{userId:\\d+}")
    public String developerPage(
            @PathVariable("usersRole") String usersRole,
            @PathVariable("userId") int id) {
        boolean requestIsCorrect =
                usersRole.equals("customers") && customerDAO.exists(id)
                        || usersRole.equals("developers") && developerDAO.exists(id)
                        || usersRole.equals("administrators") && administratorDAO.exists(id);

        if (requestIsCorrect) {
            return "/user/index.html";
        } else {
            return "redirect:/";
        }
    }
}

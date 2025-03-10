package ru.softdepot.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.config.MyUserDetails;
import ru.softdepot.core.dao.AdministratorDAO;
import ru.softdepot.core.dao.CustomerDAO;
import ru.softdepot.core.dao.DeveloperDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.User;
import ru.softdepot.messages.Message;

@Controller
public class HtmlPagesController {
    private static ProgramDAO programDAO = new ProgramDAO();
    private static DeveloperDAO developerDAO = new DeveloperDAO();
    private static CustomerDAO customerDAO = new CustomerDAO();
    private static AdministratorDAO administratorDAO = new AdministratorDAO();

    @GetMapping("/")
    public String mainPage() {
        return "/mainpage/index.html";
    }

    @GetMapping("/programs/{programId:\\d+}")
    public String programPage(@PathVariable("programId") int programId) {
        if (programDAO.exists(programId))
            return "/program/index.html";
        else {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    ru.softdepot.messages.Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            programId,
                            Message.Status.NOT_FOUND
                    )
            );
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


        boolean customerExists = usersRole.equals("customers") && customerDAO.exists(id);
        boolean developerExists = usersRole.equals("developers") && developerDAO.exists(id);
        boolean administratorExists = usersRole.equals("administrators") && administratorDAO.exists(id);

        boolean customerNotExists = usersRole.equals("customers") && !customerDAO.exists(id);
        boolean developerNotExists = usersRole.equals("developers") && !developerDAO.exists(id);
        boolean administratorNotExists = usersRole.equals("administrators") && !administratorDAO.exists(id);

        Message.Entity entity = null;
        if (customerExists || developerExists || administratorExists) return "/user/index.html";
        else if (customerNotExists)      entity = Message.Entity.CUSTOMER;
        else if (developerNotExists)     entity = Message.Entity.DEVELOPER;
        else if (administratorNotExists) entity = Message.Entity.ADMIN;

        if (entity != null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            entity,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );
        }
        else {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "Страница не найдена"
            );
        }
    }

    @GetMapping("/recommendations")
    public String getRecommendations() {
        return "/recommendations/index.html";
    }
}

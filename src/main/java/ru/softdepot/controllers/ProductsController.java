package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.util.UriComponentsBuilder;
import ru.softdepot.core.dao.*;
import ru.softdepot.core.models.Customer;
import ru.softdepot.core.models.Program;
import ru.softdepot.core.models.User;
import ru.softdepot.messages.Message;

@RestController
@AllArgsConstructor
@RequestMapping("softdepot-api/products")
public class ProductsController {
    private final ProgramDAO programDAO;
    private final DeveloperDAO developerDAO;
    private final CategoryDAO categoryDAO;
    private final UserDAO userDAO;
    private final CustomerDAO customerDAO;
    private final ReviewDAO reviewDAO;

    @GetMapping("/{id}")
    public ResponseEntity<?> findProgram(@PathVariable("id") int id) throws Exception {
        if (!programDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//        if (authentication != null && authentication.isAuthenticated()
//                && !(authentication instanceof AnonymousAuthenticationToken)) {
//            var userAuth = (org.springframework.security.core.userdetails.User) authentication.getPrincipal();
//            var user = userDAO.getByUserName(userAuth.getUsername());

        var user = getCurrentUser();
        if (user != null) {
            if (user.getUserType() == User.Type.Customer) {
                //Проверка корзины
                var program = programDAO.getById(id);
                program.setIsInCart(programDAO.isInCart(program, (Customer) user));

                //Проверка отзыва
                try {
                    var review = customerDAO.getReview((Customer) user, program);
                    program.setHasReview(review != null);
                } catch (Exception e) {
                }

                //Проверка приобретения программы
                program.setIsPurchased(customerDAO.hasPurchasedProgram((Customer) user, program));
                return ResponseEntity.ok().body(program);
            }
        }
        return ResponseEntity.ok().body(programDAO.getById(id));
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> updateProgram(@RequestBody Program program,
                                           @PathVariable("id") int id,
                                           BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!programDAO.exists(id))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.ID,
                                id,
                                Message.Status.NOT_FOUND
                        )
                );

            if (!developerDAO.exists(program.getDeveloperId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.DEVELOPER,
                                Message.Identifier.ID,
                                program.getDeveloperId(),
                                Message.Status.NOT_FOUND
                        )
                );

            var categories = program.getTags();

            for (var category : categories) {
                if (!categoryDAO.exists(category.getId()))
                    throw new ResponseStatusException(
                            HttpStatus.NOT_FOUND,
                            Message.build(
                                    Message.Entity.CATEGORY,
                                    Message.Identifier.ID,
                                    category.getId(),
                                    Message.Status.NOT_FOUND
                            )
                    );

            }

            programDAO.update(program);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProgram(@PathVariable("id") int id) {
        if (!programDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        programDAO.delete(id);
        return ResponseEntity.ok().build();
    }


    @PostMapping("/new")
    public ResponseEntity<?> addNewProgram(@RequestBody Program program,
                                           BindingResult bindingResult,
                                           UriComponentsBuilder uriComponentsBuilder) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {

            if (!programDAO.exists(program.getId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.ID,
                                program.getId(),
                                Message.Status.NOT_FOUND
                        )
                );

            if (!developerDAO.exists(program.getDeveloperId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.DEVELOPER,
                                Message.Identifier.ID,
                                program.getDeveloperId(),
                                Message.Status.NOT_FOUND
                        )
                );

            var categories = program.getTags();

            for (var category : categories) {
                if (!categoryDAO.exists(category.getId()))
                    throw new ResponseStatusException(
                            HttpStatus.NOT_FOUND,
                            Message.build(
                                    Message.Entity.CATEGORY,
                                    Message.Identifier.ID,
                                    category.getId(),
                                    Message.Status.NOT_FOUND
                            )
                    );
            }

            if (programDAO.exists(program.getName(), program.getDeveloperId()))
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.ID,
                                String.format(
                                        "%s от разработчика с id %s",
                                        program.getId(),
                                        program.getDeveloperId()),
                                Message.Status.ALREADY_EXISTS
                        )
                );

            programDAO.add(program);
            return ResponseEntity.ok().build();
        }
    }

    @GetMapping
    public ResponseEntity<?> getPrograms() {
        var user = getCurrentUser();
        if (user != null) {
            if (user.getUserType() == User.Type.Customer) {
                var allPrograms = programDAO.getAll();

                for (int i = 0; i < allPrograms.size(); i++) {
                    var program = allPrograms.get(i);
                    program.setIsInCart(programDAO.isInCart(program, (Customer) user));
                    allPrograms.set(i, program);
                }

                return ResponseEntity.ok().body(allPrograms);
            }
        }
        return ResponseEntity.ok().body(programDAO.getAll());
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            var userAuth = (org.springframework.security.core.userdetails.User) authentication.getPrincipal();
            var user = userDAO.getByUserName(userAuth.getUsername());
            return user;
        }
        return null;
    }
}

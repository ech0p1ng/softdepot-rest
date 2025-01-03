package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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

import java.util.List;

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
    public ResponseEntity<?> findProgram(@PathVariable("id") Integer id) throws Exception {
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

        var user = UsersController.getCurrentUser(userDAO);
        if (user != null) {
            if (user.getUserType() == User.Type.Customer) {
                var program = programDAO.getById(id);
                checkProgram((Customer) user, program);

                return ResponseEntity.ok().body(program);
            }
        }
        return ResponseEntity.ok().body(programDAO.getById(id));
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> updateProgram(@RequestBody Program program,
                                           @PathVariable("id") Integer id,
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
    public ResponseEntity<?> deleteProgram(@PathVariable("id") Integer id) {
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
    public ResponseEntity<?> getPrograms(
            @RequestParam(name = "developerId", required = false) String developerId) {


        List<Program> allPrograms;

        if (developerId != null) {
            int devId = Integer.parseInt(developerId);
            try {
                allPrograms = developerDAO.getPrograms(devId);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        } else {
            allPrograms = programDAO.getAll();
        }

        var user = UsersController.getCurrentUser(userDAO);
        if (user != null) {
            if (user.getUserType() == User.Type.Customer) {
                for (int i = 0; i < allPrograms.size(); i++) {
                    var program = allPrograms.get(i);
//                    program.setIsInCart(programDAO.isInCart(program, (Customer) user));
//                    program.setIsPurchased(programDAO.isPurchased(program, (Customer) user));
                    checkProgram((Customer) user, program);
                    allPrograms.set(i, program);
                }

                return ResponseEntity.ok().body(allPrograms);
            }
        }
        return ResponseEntity.ok().body(programDAO.getAll());
    }

    @GetMapping("/recommendations")
    public ResponseEntity<?> getRecommendations(
            @RequestParam("customerId") Integer customerId,
            @RequestParam(value = "minEstimation", required = false) Double minEstimation,
            @RequestParam(value = "maxPrice", required = false) Double maxPrice) {
        Customer customer;
        try {
            customer = customerDAO.getById(customerId);
        } catch (Exception e) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    ru.softdepot.messages.Message.build(
                            Message.Entity.CUSTOMER,
                            Message.Identifier.ID,
                            customerId,
                            Message.Status.NOT_FOUND
                    )
            );
        }

        if (minEstimation == null) minEstimation = 0.0;
        if (maxPrice == null) maxPrice = Double.MAX_VALUE;

        List<Program> recommendations;

        try {
            recommendations = programDAO.getRecommendations(customer, minEstimation, maxPrice);
            for (int i = 0; i < recommendations.size(); i++) {
                var program = recommendations.get(i);
                recommendations.set(i, checkProgram(customer, program));
            }

            return ResponseEntity.ok().body(recommendations);
        } catch (Exception e) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    e.getMessage()
            );
        }
    }

    private Program checkProgram(Customer customer, Program program) {
        //Проверка корзины
        program.setIsInCart(programDAO.isInCart(program, customer));
        program.setIsPurchased(programDAO.isPurchased(program, customer));

        //Проверка отзыва
        try {
            var review = customerDAO.getReview(customer, program);
            program.setHasReview(review != null);
        } catch (Exception e) {
        }

        //Проверка приобретения программы
        program.setIsPurchased(customerDAO.hasPurchasedProgram(customer, program));
        return program;
    }
}
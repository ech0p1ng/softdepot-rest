package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.messages.Message;
import ru.softdepot.core.dao.DeveloperDAO;
import ru.softdepot.core.models.Developer;

import java.sql.SQLException;

@RestController
@RequestMapping("softdepot-api/developers")
public class DevelopersController {
    private final DeveloperDAO developerDAO = new DeveloperDAO();

    @GetMapping("/{id}")
    public ResponseEntity<?> getDeveloperById(@PathVariable("id") int id) throws Exception {
        if (!developerDAO.exists(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.DEVELOPER,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );
        }

        var developer = developerDAO.getById(id);
        developer.setPassword(null);
        return ResponseEntity.ok().body(developer);
    }


    @PostMapping("/new")
    public ResponseEntity<?> addDeveloper(@RequestBody Developer developer,
                                          BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (developerDAO.exists(developer.getName())) {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.DEVELOPER,
                                Message.Identifier.EMAIL,
                                developer.getEmail(),
                                Message.Status.ALREADY_EXISTS
                        )
                );
            }
        }

        developerDAO.add(developer);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> editDeveloper(@RequestBody Developer developer,
                                           @PathVariable("id") int id,
                                           BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!developerDAO.exists(id)) {
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.DEVELOPER,
                                Message.Identifier.ID,
                                developer.getId(),
                                Message.Status.NOT_FOUND
                        )
                );
            }

            developerDAO.update(developer);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteDeveloper(@PathVariable("id") int id) {
        if (!developerDAO.exists(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.DEVELOPER,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );
        }

        developerDAO.delete(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping
    public ResponseEntity<?> getAllDevelopers() {
        return ResponseEntity.ok(developerDAO.getAll());
    }
}

package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.Messages.Message;
import ru.softdepot.core.dao.AdministratorDAO;
import ru.softdepot.core.models.Administrator;

@RestController
@RequestMapping("softdepot-api/administrators")
@AllArgsConstructor
public class AdministratorsController {
    private final AdministratorDAO administratorDAO;


    @PostMapping("/new")
    public ResponseEntity<?> addNewAdmin(@RequestBody Administrator administrator,
                                         BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (administratorDAO.exists(administrator.getEmail())) {
                return ResponseEntity
                        .badRequest()
                        .body(Message.build(
                                Message.Entity.admin,
                                Message.Identifier.email,
                                administrator.getEmail(),
                                Message.Status.notFound
                        ));
            } else {
                try {
                    administratorDAO.add(administrator);
                } catch (Exception e) {
                    return ResponseEntity
                            .badRequest()
                            .body(e.getMessage() + "\n\n" + e.getStackTrace());
                }
                return ResponseEntity.ok().build();
            }
        }
    }

    @PatchMapping("/edit/{id}")
    public ResponseEntity<?> editAdmin(@RequestBody Administrator administrator,
                                       @PathVariable("id") int id,
                                       BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (administratorDAO.exists(id)) {
                administratorDAO.update(administrator);
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(Message.build(
                                Message.Entity.admin,
                                Message.Identifier.id,
                                id,
                                Message.Status.notFound
                        ));
            }
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteAdmin(@PathVariable int id) {
        if (administratorDAO.exists(id)) {
            administratorDAO.delete(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(Message.build(
                        Message.Entity.admin,
                        Message.Identifier.id,
                        id,
                        Message.Status.notFound));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getAdmin(@PathVariable int id) {
        try {
            Administrator admin = administratorDAO.getById(id);
            return ResponseEntity.ok().body(admin);
        } catch (Exception e) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.admin,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));
        }
    }

    @GetMapping
    public ResponseEntity<?> getAllAdmins() {
        var admins = administratorDAO.getAll();
        return ResponseEntity.ok().body(admins);
    }
}
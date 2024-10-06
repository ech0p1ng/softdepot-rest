package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.Messages.Message;
import ru.softdepot.core.dao.AdministratorDAO;
import ru.softdepot.core.models.Administrator;

@RestController
@RequestMapping("softdepot-api/admins")
@AllArgsConstructor
public class AdministratorsController {
    private final AdministratorDAO administratorDAO;


    @PostMapping("/new")
    public ResponseEntity<?> addNewAdmin(@RequestBody Administrator administrator,
                                         BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (administratorDAO.exists(administrator.getEmail())) {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.ADMIN,
                                Message.Identifier.EMAIL,
                                administrator.getEmail(),
                                Message.Status.NOT_FOUND
                        )
                );
            } else {
                administratorDAO.add(administrator);
                return ResponseEntity.ok().build();
            }
        }
    }

    @PatchMapping("/edit")
    public ResponseEntity<?> editAdmin(@RequestBody Administrator administrator,
                                       @PathVariable("id") int id,
                                       BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!administratorDAO.exists(id))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.ADMIN,
                                Message.Identifier.ID,
                                id,
                                Message.Status.NOT_FOUND
                        )
                );

            administratorDAO.update(administrator);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteAdmin(@PathVariable int id) {
        if (administratorDAO.exists(id)) {
            administratorDAO.delete(id);
            return ResponseEntity.ok().build();
        }
        throw new ResponseStatusException(
                HttpStatus.NOT_FOUND,
                Message.build(
                        Message.Entity.ADMIN,
                        Message.Identifier.ID,
                        id,
                        Message.Status.NOT_FOUND
                )
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getAdmin(@PathVariable int id) throws Exception {
        if (!administratorDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.ADMIN,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );
        Administrator admin = administratorDAO.getById(id);
        return ResponseEntity.ok().body(admin);
    }

    @GetMapping
    public ResponseEntity<?> getAllAdmins() {
        var admins = administratorDAO.getAll();
        return ResponseEntity.ok().body(admins);
    }
}
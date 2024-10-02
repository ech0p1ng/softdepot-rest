package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;
import ru.softdepot.core.dao.AdministratorDAO;
import ru.softdepot.core.models.Administrator;
import ru.softdepot.core.models.Program;

import java.util.Map;

@RestController("softdepot-api/administrators")
@AllArgsConstructor
public class AdministratorsController {
    private final AdministratorDAO administratorDAO;
    private final String adminNotFoundByEmail = "Администратор с таким email не найден";
    private final String adminNotFoundById = "Администратор с таким id не найден";

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
                        .body("Администратор с таким email уже существует");
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

    @PatchMapping("/edit")
    public ResponseEntity<?> editAdmin(@RequestBody Administrator administrator,
                                       BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (administratorDAO.exists(administrator.getEmail())) {
                administratorDAO.update(administrator);
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(adminNotFoundByEmail);
            }
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteAdmin(@PathVariable int id,
                                         BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (administratorDAO.exists(id)) {
                administratorDAO.delete(id);
                return ResponseEntity.ok().build();
            }
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(adminNotFoundById);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getAdmin(@PathVariable int id,
                                      BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            try {
                Administrator admin = administratorDAO.getById(id);
                return ResponseEntity.ok().body(admin);
            } catch (Exception e) {
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(adminNotFoundById);
            }
        }
    }

    @GetMapping
    public ResponseEntity<?> getAllAdmins(BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            var admins = administratorDAO.getAll();
            return ResponseEntity.ok().body(admins);
        }
    }


}
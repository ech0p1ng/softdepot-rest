package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.core.dao.DeveloperDAO;
import ru.softdepot.core.models.Developer;

@RestController
@RequestMapping("softdepot-api/developers")
@AllArgsConstructor
public class DevelopersController {
    private final DeveloperDAO developerDAO;

    private static String developerNotFound(int id) {
        return String.format("Разработчик с id = %s не найден", id);
    }

    private static String developerNotFound(String email) {
        return String.format("Разработчик с email = %s не найден", email);
    }

    private static String developerAlreadyExists(String email) {
        return String.format("Разработчик с email = %s уже существует", email);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getDeveloperById(@PathVariable("id") int id) {
        if (!developerDAO.exists(id)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(developerNotFound(id));
        }

        try {
            var developer = developerDAO.getById(id);
            return ResponseEntity.ok().body(developer);
        } catch (Exception e) {
            return ResponseEntity
                    .badRequest()
                    .body(e.getMessage() + "\n\n" + e.getStackTrace());
        }
    }


    @PostMapping("/new")
    public ResponseEntity<?> addDeveloper(@RequestBody Developer developer,
                                          BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (developerDAO.exists(developer.getEmail())) {
                return ResponseEntity
                        .badRequest()
                        .body(developerAlreadyExists(developer.getEmail()));
            }
        }

        try {
            developerDAO.add(developer);
        } catch (Exception e) {
            return ResponseEntity
                    .badRequest()
                    .body(e.getMessage() + "\n\n" + e.getStackTrace());
        }
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/edit")
    public ResponseEntity<?> editDeveloper(@RequestBody Developer developer,
                                           BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!developerDAO.exists(developer.getId())) {
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(developerNotFound(developer.getId()));
            }

            developerDAO.update(developer);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteDeveloper(@PathVariable("id") int id) {
        if (!developerDAO.exists(id)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(developerNotFound(id));
        }

        developerDAO.delete(id);
        return ResponseEntity.ok().build();
    }
}

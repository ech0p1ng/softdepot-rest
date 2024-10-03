package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.softdepot.core.dao.DeveloperDAO;

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

}

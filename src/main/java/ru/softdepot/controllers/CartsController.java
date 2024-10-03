package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.core.dao.CartDAO;
import ru.softdepot.core.dao.CustomerDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.Program;

@RestController
@RequestMapping("softdepot-api/carts")
@AllArgsConstructor
public class CartsController {
    private final CartDAO cartDAO;
    private final CustomerDAO customerDAO;
    private final ProgramDAO programDAO;

    private static String customerNotFound(int id) {
        return String.format("Пользователь с id = %d не найден", id);
    }

    private static String programNotFound(int id) {
        return String.format("Программа с id = %d не найдена", id);
    }

    private static String cartNotFound(int id) {
        return String.format("Корзина с id = %d не найдена", id);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<?> getPrograms(@PathVariable("userId") int id) {
        if (customerDAO.exists(id)) {
            var programs = cartDAO.getPrograms(id);
            return ResponseEntity.ok().body(programs);
        } else {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(customerNotFound(id));
        }
    }

    @DeleteMapping("/delete")
    public ResponseEntity<?> deleteProgram(@RequestParam("userId") int id,
                                           @RequestParam("programId") int programId) {
        if (!customerDAO.exists(id))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(customerNotFound(id));

        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(programNotFound(id));

        if (!cartDAO.containsProgram(id, programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(cartNotFound(id));

        cartDAO.deleteProgram(id, programId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/add")
    public ResponseEntity<?> addProgram(@RequestParam("userId") int id,
                                        @RequestParam("programId") int programId) {
        if (!customerDAO.exists(id))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(customerNotFound(id));

        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(programNotFound(id));

        if (!cartDAO.containsProgram(id, programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(cartNotFound(id));

        cartDAO.addProgram(id, programId);
        return ResponseEntity.ok().build();
    }
}

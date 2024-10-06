package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.Messages.Message;
import ru.softdepot.core.dao.CartDAO;
import ru.softdepot.core.dao.CustomerDAO;
import ru.softdepot.core.dao.ProgramDAO;

@RestController
@RequestMapping("softdepot-api/carts")
@AllArgsConstructor
public class CartsController {
    private final CartDAO cartDAO;
    private final CustomerDAO customerDAO;
    private final ProgramDAO programDAO;

    @GetMapping("/{userId}")
    public ResponseEntity<?> getPrograms(@PathVariable("userId") int id) {
        if (customerDAO.exists(id)) {
            var programs = cartDAO.getPrograms(id);
            return ResponseEntity.ok().body(programs);
        } else {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.customer,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));
        }
    }

    @DeleteMapping(value = "/delete", params = {"userId", "programId"})
    public ResponseEntity<?> deleteProgram(@RequestParam("userId") int id,
                                           @RequestParam("programId") int programId) {
        var errorMessage = check(id, programId);
        if (errorMessage != null) return errorMessage;

        cartDAO.deleteProgram(id, programId);
        return ResponseEntity.ok().build();
    }

    @PostMapping(value = "/add", params = {"userId", "programId"})
    public ResponseEntity<?> addProgram(@RequestParam("userId") int id,
                                        @RequestParam("programId") int programId) {

        var errorMessage = check(id, programId);
        if (errorMessage != null) return errorMessage;

        cartDAO.addProgram(id, programId);
        return ResponseEntity.ok().build();
    }

    private ResponseEntity<?> check(int id, int programId) {
        if (!customerDAO.exists(id))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.customer,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));

        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            programId,
                            Message.Status.notFound
                    ));

        if (!cartDAO.containsProgram(id, programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.cart,
                            Message.Identifier.id,
                            programId,
                            Message.Status.notFound
                    ));

        return null;
    }
}

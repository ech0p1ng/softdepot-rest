package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.messages.Message;
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
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CUSTOMER,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );
        }
    }

    @DeleteMapping(value = "/{userId}", params = {"programId"})
    public ResponseEntity<?> deleteProgram(@PathVariable("userId") int id,
                                           @RequestParam("programId") int programId) {
        var errorMessage = check(id, programId);
        if (errorMessage != null) throw errorMessage;

        cartDAO.deleteProgram(id, programId);
        return ResponseEntity.ok().build();
    }

    @PostMapping(value = "/{userId}", params = {"programId"})
    public ResponseEntity<?> addProgram(@PathVariable("userId") int id,
                                        @RequestParam("programId") int programId) {

        var errorMessage = check(id, programId);
        if (errorMessage != null) throw errorMessage;

        cartDAO.addProgram(id, programId);
        return ResponseEntity.ok().build();
    }

    private ResponseStatusException check(int id, int programId) {
        if (!customerDAO.exists(id))
            return new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CUSTOMER,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        if (!programDAO.exists(programId))
            return new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            programId,
                            Message.Status.NOT_FOUND
                    )
            );

        if (!cartDAO.containsProgram(id, programId))
            return new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CART,
                            Message.Identifier.ID,
                            programId,
                            Message.Status.NOT_FOUND
                    )
            );

        return null;
    }
}

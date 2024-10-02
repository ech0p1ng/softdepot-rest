package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.core.dao.CartDAO;
import ru.softdepot.core.dao.CustomerDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.Program;

@RestController("softdepot-api/carts")
@AllArgsConstructor
public class CartsController {
    private final CartDAO cartDAO;
    private final CustomerDAO customerDAO;
    private final ProgramDAO programDAO;

    @GetMapping("/{userId}")
    public ResponseEntity<?> getPrograms(@PathVariable("userId") int id,
                                         BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (customerDAO.exists(id)) {
                var programs = cartDAO.getPrograms(id);
                return ResponseEntity.ok().body(programs);
            } else {
                return ResponseEntity.notFound().build();
            }
        }
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<?> deleteProgram(@PathVariable("userId") int id,
                                           @RequestParam("programId") int programId,
                                           BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!customerDAO.exists(id))
                return ResponseEntity.notFound().build();

            if (!programDAO.exists(programId))
                return ResponseEntity.notFound().build();

            if (!cartDAO.containsProgram(id, programId))
                return ResponseEntity.notFound().build();

            cartDAO.deleteProgram(id, programId);
            return ResponseEntity.ok().build();
        }
    }

    @PostMapping("/{userId}")
    public ResponseEntity<?> addProgram(@PathVariable("userId") int id,
                                        @RequestParam("programId") int programId,
                                        BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!customerDAO.exists(id))
                return ResponseEntity.notFound().build();

            if (!programDAO.exists(programId))
                return ResponseEntity.notFound().build();

            if (!cartDAO.containsProgram(id, programId))
                return ResponseEntity.notFound().build();

            cartDAO.addProgram(id, programId);
            return ResponseEntity.ok().build();
        }
    }
}

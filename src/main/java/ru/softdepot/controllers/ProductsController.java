package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;
import ru.softdepot.Messages.Message;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.Program;

import java.util.List;
import java.util.Map;

@RestController
@AllArgsConstructor
@RequestMapping("softdepot-api/products")
public class ProductsController {
    private final ProgramDAO programDAO;

    @GetMapping("/{id}")
    public Program findProgram(@PathVariable("id") int id) throws Exception {
        return this.programDAO.getById(id);
    }

    @PatchMapping("/edit")
    public ResponseEntity<?> updateProgram(@RequestBody Program program,
                                           BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) {
                throw exception;
            } else {
                throw new BindException(bindingResult);
            }
        } else {
            this.programDAO.update(program);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteProgram(@PathVariable("id") int id) {
        this.programDAO.delete(id);
        return ResponseEntity.ok().build();
    }


    @PostMapping("/new")
    public ResponseEntity<?> addNewProgram(@RequestBody Program program,
                                           BindingResult bindingResult,
                                           UriComponentsBuilder uriComponentsBuilder) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {

            if (programDAO.exists(program.getId()))
                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .body(Message.build(
                                Message.Entity.product,
                                Message.Identifier.id,
                                program.getId(),
                                Message.Status.alreadyExists
                        ));
            if (programDAO.exists(program.getName(), program.getDeveloperId()))
                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .body(Message.build(
                                Message.Entity.product,
                                Message.Identifier.id,
                                String.format(
                                        "%s от разработчика с id %s",
                                        program.getId(),
                                        program.getDeveloperId()),
                                Message.Status.alreadyExists
                        ));



            int id = this.programDAO.add(program);
            Program programResult;
            try {
                programResult = this.programDAO.getById(id);
            } catch (Exception e) {
                return ResponseEntity
                        .badRequest()
                        .body(e.getMessage() + "\n\n" + e.getStackTrace());
            }
            return ResponseEntity
                    .created(uriComponentsBuilder
                            .replacePath("/softdepot-api/products/{id}")
                            .build(Map.of("id", id)))
                    .body(programResult);
        }
    }

    @GetMapping
    public ResponseEntity<?> getPrograms() {
        return ResponseEntity.ok().body(this.programDAO.getAll());
    }
}

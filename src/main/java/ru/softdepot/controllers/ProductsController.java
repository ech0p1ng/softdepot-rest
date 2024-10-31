package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.util.UriComponentsBuilder;
import ru.softdepot.messages.Message;
import ru.softdepot.core.dao.CategoryDAO;
import ru.softdepot.core.dao.DeveloperDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.Program;

@RestController
@AllArgsConstructor
@RequestMapping("softdepot-api/products")
public class ProductsController {
    private final ProgramDAO programDAO;
    private final DeveloperDAO developerDAO;
    private final CategoryDAO categoryDAO;

    @GetMapping("/{id}")
    public ResponseEntity<?> findProgram(@PathVariable("id") int id) throws Exception {
        if (!programDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        var program = programDAO.getById(id);
        System.out.println(program.getFilesPath());
        return ResponseEntity.ok().body(program);
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> updateProgram(@RequestBody Program program,
                                           @PathVariable("id") int id,
                                           BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!programDAO.exists(id))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.ID,
                                id,
                                Message.Status.NOT_FOUND
                        )
                );

            if (!developerDAO.exists(program.getDeveloperId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.DEVELOPER,
                                Message.Identifier.ID,
                                program.getDeveloperId(),
                                Message.Status.NOT_FOUND
                        )
                );

            var categories = program.getTags();

            for (var category : categories) {
                if (!categoryDAO.exists(category.getId()))
                    throw new ResponseStatusException(
                            HttpStatus.NOT_FOUND,
                            Message.build(
                                    Message.Entity.CATEGORY,
                                    Message.Identifier.ID,
                                    category.getId(),
                                    Message.Status.NOT_FOUND
                            )
                    );

            }

            programDAO.update(program);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProgram(@PathVariable("id") int id) {
        if (!programDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        programDAO.delete(id);
        return ResponseEntity.ok().build();
    }


    @PostMapping("/new")
    public ResponseEntity<?> addNewProgram(@RequestBody Program program,
                                           BindingResult bindingResult,
                                           UriComponentsBuilder uriComponentsBuilder) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {

            if (!programDAO.exists(program.getId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.ID,
                                program.getId(),
                                Message.Status.NOT_FOUND
                        )
                );

            if (!developerDAO.exists(program.getDeveloperId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.DEVELOPER,
                                Message.Identifier.ID,
                                program.getDeveloperId(),
                                Message.Status.NOT_FOUND
                        )
                );

            var categories = program.getTags();

            for (var category : categories) {
                if (!categoryDAO.exists(category.getId()))
                    throw new ResponseStatusException(
                            HttpStatus.NOT_FOUND,
                            Message.build(
                                    Message.Entity.CATEGORY,
                                    Message.Identifier.ID,
                                    category.getId(),
                                    Message.Status.NOT_FOUND
                            )
                    );
            }

            if (programDAO.exists(program.getName(), program.getDeveloperId()))
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.ID,
                                String.format(
                                        "%s от разработчика с id %s",
                                        program.getId(),
                                        program.getDeveloperId()),
                                Message.Status.ALREADY_EXISTS
                        )
                );


//            int id = this.programDAO.add(program);
//            Program programResult = this.programDAO.getById(id);
//            return ResponseEntity
//                    .created(uriComponentsBuilder
//                            .replacePath("/softdepot-api/products/{id}")
//                            .build(Map.of("id", id)))
//                    .body(programResult);
            programDAO.add(program);
            return ResponseEntity.ok().build();
        }
    }

    @GetMapping
    public ResponseEntity<?> getPrograms() {
        return ResponseEntity.ok().body(programDAO.getAll());
    }
}

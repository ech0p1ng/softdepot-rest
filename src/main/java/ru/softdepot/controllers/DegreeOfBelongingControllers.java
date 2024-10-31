package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.messages.Message;
import ru.softdepot.core.dao.CategoryDAO;
import ru.softdepot.core.dao.DegreeOfBelongingDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.DegreeOfBelonging;

@RestController
@RequestMapping("softdepot-api/degrees-of-belonging")
@AllArgsConstructor
public class DegreeOfBelongingControllers {
    private final DegreeOfBelongingDAO degreeOfBelongingDAO;
    private final ProgramDAO programDAO;
    private final CategoryDAO categoryDAO;

    @PostMapping("/new")
    public ResponseEntity<?> addNewDegreeOfBelonging(@RequestBody DegreeOfBelonging degreeOfBelonging,
                                                     BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            int programId = degreeOfBelonging.getProgramId();
            int categoryId = degreeOfBelonging.getTagId();

            var errorMessage = check(programId, categoryId);
            if (errorMessage != null) throw errorMessage;

            degreeOfBelongingDAO.add(degreeOfBelonging);
            return ResponseEntity.ok().build();
        }
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> updateDegreeOfBelonging(@RequestBody DegreeOfBelonging degreeOfBelonging,
                                                     @PathVariable("id") int id,
                                                     BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            var errorMessage = check(id);
            if (errorMessage != null) throw errorMessage;

            degreeOfBelongingDAO.update(degreeOfBelonging);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteDegreeOfBelonging(@PathVariable("id") int id) {
        var errorMessage = check(id);
        if (errorMessage != null) throw errorMessage;

        degreeOfBelongingDAO.delete(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getDegreeOfBelonging(@PathVariable int id) {
        var errorMessage = check(id);
        if (errorMessage != null) throw errorMessage;

        return ResponseEntity.ok().body(degreeOfBelongingDAO.getById(id));
    }

    @GetMapping(params = {"programId", "categoryId"})
    public ResponseEntity<?> getDegreeOfBelonging(@RequestParam("programId") int programId,
                                                  @RequestParam("categoryId") int categoryId) {
        var errorMessage = check(programId, categoryId);
        if (errorMessage != null) throw errorMessage;

        return ResponseEntity.ok().body(
                degreeOfBelongingDAO.getByTagAndProgram(categoryId, programId)
        );
    }

    @GetMapping
    public ResponseEntity<?> getAllDegreesOfBelonging() {
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(degreeOfBelongingDAO.getAll());
    }

    private ResponseStatusException check(int id) {
        if (!degreeOfBelongingDAO.exists(id))
            return new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.DEGREE_OF_BELONGING,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        var degreeOfBelonging = degreeOfBelongingDAO.getById(id);

        if (!programDAO.exists(degreeOfBelonging.getProgramId()))
            return new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            degreeOfBelonging.getProgramId(),
                            Message.Status.NOT_FOUND
                    )
            );

        if (!categoryDAO.exists(degreeOfBelonging.getTagId()))
            return new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CATEGORY,
                            Message.Identifier.ID,
                            degreeOfBelonging.getTagId(),
                            Message.Status.NOT_FOUND
                    )
            );
        return null;
    }

    private ResponseStatusException check(int programId, int categoryId) {
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

        if (!categoryDAO.exists(categoryId))
            return new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CATEGORY,
                            Message.Identifier.ID,
                            categoryId,
                            Message.Status.NOT_FOUND
                    )
            );

        if (!degreeOfBelongingDAO.exists(programId, categoryId))
            return new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    Message.build(
                            Message.Entity.DEGREE_OF_BELONGING,
                            Message.Identifier.ID,
                            String.format("%s программы к категории с id %s",
                                    programId,
                                    categoryId),
                            Message.Status.ALREADY_EXISTS
                    )
            );

        return null;
    }
}

package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.Messages.Message;
import ru.softdepot.core.dao.CategoryDAO;
import ru.softdepot.core.dao.DegreeOfBelongingDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.DegreeOfBelonging;

@RestController
@RequestMapping("softdepot-api/degree-of-belonging")
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
            var errorMessage = check(degreeOfBelonging.getProgramId(), degreeOfBelonging.getTagId());
            if (errorMessage != null) return errorMessage;

            degreeOfBelongingDAO.add(degreeOfBelonging);
            return ResponseEntity.ok().build();
        }
    }

    @PatchMapping("/edit")
    public ResponseEntity<?> updateDegreeOfBelonging(@RequestBody DegreeOfBelonging degreeOfBelonging,
                                                     BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {

            var errorMessage = check(degreeOfBelonging.getProgramId(), degreeOfBelonging.getTagId());
            if (errorMessage != null) return errorMessage;

            degreeOfBelongingDAO.update(degreeOfBelonging);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/delete")
    public ResponseEntity<?> deleteDegreeOfBelonging(@RequestParam("programId") int programId,
                                                     @RequestParam("categoryId") int categoryId) {
        var errorMessage = check(programId, categoryId);
        if (errorMessage != null) return errorMessage;

        degreeOfBelongingDAO.delete(programId, categoryId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getDegreeOfBelonging(@PathVariable int id) {
        if (!degreeOfBelongingDAO.exists(id)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.degreeOfBelonging,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));
        }
        var degreeOfBelonging = degreeOfBelongingDAO.getById(id);

        var errorMessage = check(degreeOfBelonging.getProgramId(), degreeOfBelonging.getTagId());
        if (errorMessage != null) return errorMessage;

        return ResponseEntity.ok().body(degreeOfBelonging);
    }

    @GetMapping
    public ResponseEntity<?> getDegreeOfBelonging(@RequestParam("programId") int programId,
                                                  @RequestParam("categoryId") int categoryId) {
        var errorMessage = check(programId, categoryId);
        if (errorMessage != null) return errorMessage;

        var degreeOfBelonging = degreeOfBelongingDAO.getByTagAndProgram(categoryId, programId);
        return ResponseEntity.ok().body(degreeOfBelonging);
    }

    private ResponseEntity<?> check(int programId, int categoryId) {
        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            programId,
                            Message.Status.notFound
                    ));

        if (!categoryDAO.exists(categoryId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.category,
                            Message.Identifier.id,
                            categoryId,
                            Message.Status.notFound
                    ));

        if (!degreeOfBelongingDAO.exists(programId, categoryId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.degreeOfBelonging,
                            Message.Identifier.id,
                            String.format("%s программы к категории с id = %s", programId, categoryId),
                            Message.Status.notFound
                    ));
        return null;
    }
}

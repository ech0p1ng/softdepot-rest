package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.core.dao.CategoryDAO;
import ru.softdepot.core.dao.DegreeOfBelongingDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.DailyStats;
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
            if (!programDAO.exists(degreeOfBelonging.getProgramId()))
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(programNotFound(degreeOfBelonging.getProgramId()));

            if (!categoryDAO.exists(degreeOfBelonging.getTagId()))
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(categoryNotFound(degreeOfBelonging.getTagId()));

            if (!degreeOfBelongingDAO.exists(
                    degreeOfBelonging.getProgramId(),
                    degreeOfBelonging.getTagId()))
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(degreeOfBelongingNotFound(
                                degreeOfBelonging.getProgramId(),
                                degreeOfBelonging.getTagId()));

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

            if (!programDAO.exists(degreeOfBelonging.getProgramId()))
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(programNotFound(degreeOfBelonging.getProgramId()));

            if (!categoryDAO.exists(degreeOfBelonging.getTagId()))
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(categoryNotFound(degreeOfBelonging.getTagId()));

            degreeOfBelongingDAO.update(degreeOfBelonging);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/delete")
    public ResponseEntity<?> deleteDegreeOfBelonging(@RequestParam("programId") int programId,
                                                     @RequestParam("categoryId") int categoryId) {
        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(programNotFound(programId));

        if (!categoryDAO.exists(categoryId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(categoryNotFound(categoryId));

        if (!degreeOfBelongingDAO.exists(programId, categoryId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(degreeOfBelongingNotFound(programId, categoryId));
        degreeOfBelongingDAO.delete(programId, categoryId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getDegreeOfBelonging(@PathVariable int id) {
        if (!degreeOfBelongingDAO.exists(id)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(degreeOfBelongingNotFound(id));
        }
        var degreeOfBelonging = degreeOfBelongingDAO.getById(id);

        if (!categoryDAO.exists(degreeOfBelonging.getTagId()))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(categoryNotFound(degreeOfBelonging.getTagId()));

        if (!degreeOfBelongingDAO.exists(
                degreeOfBelonging.getProgramId(),
                degreeOfBelonging.getTagId()))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(degreeOfBelongingNotFound(
                            degreeOfBelonging.getProgramId(),
                            degreeOfBelonging.getTagId()));

        return ResponseEntity.ok().body(degreeOfBelonging);
    }

    @GetMapping
    public ResponseEntity<?> getDegreeOfBelonging(@RequestParam("programId") int programId,
                                                  @RequestParam("categoryId") int categoryId) {
        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(programNotFound(programId));

        if (!categoryDAO.exists(categoryId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(categoryNotFound(categoryId));

        if (!degreeOfBelongingDAO.exists(programId, categoryId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(degreeOfBelongingNotFound(programId, categoryId));

        var degreeOfBelonging = degreeOfBelongingDAO.getByTagAndProgram(categoryId, programId);
        return ResponseEntity.ok().body(degreeOfBelonging);
    }

    private static String programNotFound(int id) {
        return String.format(
                "Программа с id = %s не найдена",
                id
        );
    }

    private static String categoryNotFound(int id) {
        return String.format(
                "Категория с id = %s не найдена",
                id
        );
    }

    private static String degreeOfBelongingNotFound(int programId, int tagId) {
        return String.format(
                "Степень принадлежности программы с id = %s к категории с id = %s не найдена",
                programId, tagId
        );
    }

    private static String degreeOfBelongingNotFound(int id) {
        return String.format(
                "Степень принадлежности с id = %s не найдена",
                id
        );
    }
}

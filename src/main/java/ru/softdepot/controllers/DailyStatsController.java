package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.Messages.Message;
import ru.softdepot.core.dao.DailyStatsDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.DailyStats;
import ru.softdepot.core.models.Program;

@RestController
@RequestMapping("/softdepot-api/daily-stats")
@AllArgsConstructor
public class DailyStatsController {
    private final DailyStatsDAO dailyStatsDAO;
    private final ProgramDAO programDAO;

    @PostMapping("/new")
    public ResponseEntity<?> addNewDailyStats(@RequestBody DailyStats dailyStats,
                                              BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!programDAO.exists(dailyStats.getProgramId()))
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(Message.build(
                                Message.Entity.product,
                                Message.Identifier.id,
                                dailyStats.getProgramId(),
                                Message.Status.notFound
                        ));
            dailyStatsDAO.add(dailyStats);
            return ResponseEntity.ok().build();
        }
    }

    @PatchMapping("/edit")
    public ResponseEntity<?> updateDailyStats(@RequestBody DailyStats dailyStats,
                                              BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            var errorMessage = check(dailyStats.getId(), dailyStats.getProgramId());
            if (errorMessage != null) return errorMessage;

            dailyStatsDAO.update(dailyStats);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteDailyStats(@PathVariable("id") int id) {
        if (!dailyStatsDAO.exists(id)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.dailyStats,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));
        }

        var dailyStats = dailyStatsDAO.getById(id);

        if (!programDAO.exists(dailyStats.getProgramId()))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            dailyStats.getProgramId(),
                            Message.Status.notFound
                    ));

        dailyStatsDAO.delete(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getDailyStats(@PathVariable("id") int id) {
        if (!dailyStatsDAO.exists(id)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.dailyStats,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));
        }

        var dailyStats = dailyStatsDAO.getById(id);

        if (!programDAO.exists(dailyStats.getProgramId()))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            dailyStats.getProgramId(),
                            Message.Status.notFound
                    ));

        return ResponseEntity.ok().body(dailyStats);
    }

    @GetMapping("/list")
    public ResponseEntity<?> getDailyStatsList(@RequestParam("programId") int programId) {
        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            programId,
                            Message.Status.notFound
                    ));

        var stats = dailyStatsDAO.getByProgramId(programId);
        return ResponseEntity.ok().body(stats);
    }

    private ResponseEntity<?> check(int dailyStatsId, int programId) {
        if (!dailyStatsDAO.exists(dailyStatsId)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.dailyStats,
                            Message.Identifier.id,
                            dailyStatsId,
                            Message.Status.notFound
                    ));
        }

        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            programId,
                            Message.Status.notFound
                    ));
        return null;
    }
}

package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.messages.Message;
import ru.softdepot.core.dao.DailyStatsDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.DailyStats;

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
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.ID,
                                dailyStats.getProgramId(),
                                Message.Status.NOT_FOUND
                        )
                );
            dailyStatsDAO.add(dailyStats);
            return ResponseEntity.ok().build();
        }
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> updateDailyStats(@RequestBody DailyStats dailyStats,
                                              @PathVariable("id") int id,
                                              BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!dailyStatsDAO.exists(id))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.DAILY_STATS,
                                Message.Identifier.ID,
                                dailyStats.getId(),
                                Message.Status.NOT_FOUND
                        )
                );

            if (!programDAO.exists(dailyStats.getProgramId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.ID,
                                dailyStats.getProgramId(),
                                Message.Status.NOT_FOUND
                        )
                );

            dailyStatsDAO.update(dailyStats);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteDailyStats(@PathVariable("id") int id) {
        if (!dailyStatsDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.DAILY_STATS,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );


        var dailyStats = dailyStatsDAO.getById(id);

        if (!programDAO.exists(dailyStats.getProgramId()))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            dailyStats.getProgramId(),
                            Message.Status.NOT_FOUND
                    )
            );

        dailyStatsDAO.delete(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getDailyStats(@PathVariable("id") int id) {
        if (!dailyStatsDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.DAILY_STATS,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        var dailyStats = dailyStatsDAO.getById(id);

        if (!programDAO.exists(dailyStats.getProgramId()))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            dailyStats.getProgramId(),
                            Message.Status.NOT_FOUND
                    )
            );

        return ResponseEntity.ok().body(dailyStats);
    }

    @GetMapping(value = "/list", params = {"programId"})
    public ResponseEntity<?> getDailyStatsList(@RequestParam("programId") int programId) {
        if (!programDAO.exists(programId))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            programId,
                            Message.Status.NOT_FOUND
                    )
            );

        var stats = dailyStatsDAO.getByProgramId(programId);
        return ResponseEntity.ok().body(stats);
    }
}

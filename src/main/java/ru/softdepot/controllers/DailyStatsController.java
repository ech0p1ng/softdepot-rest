package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.core.dao.DailyStatsDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.models.DailyStats;
import ru.softdepot.core.models.Program;

@RestController
@RequestMapping("/softdepot-api/dailystats")
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
                        .body(programNotFound(dailyStats.getProgramId()));
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
            if (!dailyStatsDAO.exists(dailyStats.getId()))
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(dailyStatsNotFound(dailyStats.getId()));

            if (!programDAO.exists(dailyStats.getProgramId()))
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(programNotFound(dailyStats.getProgramId()));

            dailyStatsDAO.update(dailyStats);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteDailyStats(@PathVariable("id") int id) {
        if (!dailyStatsDAO.exists(id)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(dailyStatsNotFound(id));
        }

        DailyStats dailyStats = dailyStatsDAO.getById(id);

        if (!programDAO.exists(dailyStats.getProgramId()))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(programNotFound(id));

        dailyStatsDAO.delete(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping
    public ResponseEntity<?> getDailyStats(@RequestParam("id") int id) {
        if (!dailyStatsDAO.exists(id)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(dailyStatsNotFound(id));
        }

        DailyStats dailyStats = dailyStatsDAO.getById(id);

        if (!programDAO.exists(dailyStats.getProgramId()))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(programNotFound(id));

        return ResponseEntity.ok().body(dailyStats);
    }

    @GetMapping
    public ResponseEntity<?> getDailyStatsList(@RequestParam("programId") int programId) {
        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(programNotFound(programId));

        var stats = dailyStatsDAO.getByProgramId(programId);
        return ResponseEntity.ok().body(stats);
    }

    private static String dailyStatsNotFound(int id) {
        return String.format(
                "Ежедневная статистика с id = %s не найдена",
                id
        );
    }

    private static String programNotFound(int id) {
        return String.format(
                "Программа с id = %s не найдена",
                id
        );
    }
}

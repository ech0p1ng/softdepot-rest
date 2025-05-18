package ru.softdepot.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.server.ResponseStatusException;

import java.util.Arrays;
import java.util.List;

@org.springframework.web.bind.annotation.ControllerAdvice
public class ControllerAdvice {
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ProblemDetail> exceptionHandler(Exception e) {
        ProblemDetail problemDetail = ProblemDetail
                .forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage());

        if (e instanceof ResponseStatusException) {
            problemDetail.setStatus((HttpStatus) ((ResponseStatusException) e).getStatusCode());
            var messages = Arrays.asList(((ResponseStatusException) e).getReason());
            problemDetail.setProperty("message", messages);
            return ResponseEntity.status(
                    ((ResponseStatusException) e).getStatusCode()
            ).body(problemDetail);
        }
        else if (e instanceof BindException) {
            List<String> errorMessages = ((BindException) e).getBindingResult()
                    .getAllErrors()
                    .stream()
                    .map(ObjectError::getDefaultMessage)
                    .toList();
            problemDetail.setProperty("message", errorMessages);
            return ResponseEntity.badRequest().body(problemDetail);
        }
        else {
            problemDetail.setProperty("message", Arrays.asList(e));
            return ResponseEntity.internalServerError().body(problemDetail);
        }

    }
}

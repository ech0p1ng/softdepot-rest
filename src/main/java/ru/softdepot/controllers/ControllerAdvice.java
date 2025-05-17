package ru.softdepot.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.server.ResponseStatusException;

@org.springframework.web.bind.annotation.ControllerAdvice
public class ControllerAdvice {
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ProblemDetail> exceptionHandler(Exception e) {
        ProblemDetail problemDetail = ProblemDetail
                .forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage());

        if (e instanceof ResponseStatusException) {
            problemDetail.setStatus((HttpStatus) ((ResponseStatusException) e).getStatusCode());
            problemDetail.setProperty("message", ((ResponseStatusException) e).getReason());
            return ResponseEntity.status(
                    ((ResponseStatusException) e).getStatusCode()
            ).body(problemDetail);
        }
        else if (e instanceof BindException) {
//            problemDetail.setProperty("errors",
//                    ((BindException) e).getAllErrors()
//                            .stream()
//                            .map(ObjectError::getDefaultMessage));
            return ResponseEntity.badRequest().body(problemDetail);
        }
        else {
            problemDetail.setProperty("errors", e);
            return ResponseEntity.internalServerError().body(problemDetail);
        }

    }
}

package ru.softdepot.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class BadRequestControllerAdvice {
    @ExceptionHandler(BindException.class)
    public ResponseEntity<ProblemDetail> bindExceptionHandler(BindException ex, String errorMessage) {
        ProblemDetail problemDetail = ProblemDetail
                .forStatusAndDetail(HttpStatus.BAD_REQUEST, errorMessage);
        problemDetail.setProperty("errors",
                ex.getAllErrors().stream().map(ObjectError::getDefaultMessage)
        );
        return ResponseEntity.badRequest().body(problemDetail);
    }
}

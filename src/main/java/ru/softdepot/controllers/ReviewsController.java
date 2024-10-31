package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.messages.Message;
import ru.softdepot.core.dao.CustomerDAO;
import ru.softdepot.core.dao.ProgramDAO;
import ru.softdepot.core.dao.ReviewDAO;
import ru.softdepot.core.models.Review;

@RestController
@RequestMapping("softdepot-api/reviews")
@AllArgsConstructor
public class ReviewsController {
    private final ReviewDAO reviewDAO;
    private final CustomerDAO customerDAO;
    private final ProgramDAO programDAO;


    @PostMapping("/new")
    public ResponseEntity<?> newReview(@RequestBody Review review,
                                       BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            var errorMessage = check(review.getCustomerId(), review.getProgramId());
            if (errorMessage != null) throw errorMessage;

            if (reviewDAO.exists(review.getCustomerId(), review.getProgramId()))
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.REVIEW,
                                Message.Identifier.ID,
                                String.format("id %s покупателя и id %s товара",
                                        review.getCustomerId(),
                                        review.getProgramId()),
                                Message.Status.ALREADY_EXISTS
                        )
                );

            reviewDAO.add(review);
            return ResponseEntity.ok().build();
        }
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> editReview(@RequestBody Review review,
                                        @PathVariable("id") int id,
                                        BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!reviewDAO.exists(id))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.REVIEW,
                                Message.Identifier.ID,
                                id,
                                Message.Status.NOT_FOUND
                        )
                );

            var errorMessage = check(review.getCustomerId(), review.getProgramId());
            if (errorMessage != null) throw errorMessage;

            reviewDAO.update(review);
            return ResponseEntity.ok().build();
        }
    }

    @GetMapping(params = {"programId"})
    public ResponseEntity<?> getReviewsForProgram(@RequestParam("programId") int programId) {
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

        return ResponseEntity.ok().body(reviewDAO.getAllAboutProgram(programId));
    }

    @GetMapping(params = {"customerId"})
    public ResponseEntity<?> getReviewsOfCustomer(@RequestParam("customerId") int customerId) {
        if (!customerDAO.exists(customerId))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CUSTOMER,
                            Message.Identifier.ID,
                            customerId,
                            Message.Status.NOT_FOUND
                    )
            );

        return ResponseEntity.ok().body(reviewDAO.getAllByCustomer(customerId));
    }

    @GetMapping(params = {"programId", "customerId"})
    public ResponseEntity<?> getCustomersReviewsOfProgram(@RequestParam("programId") int programId,
                                                          @RequestParam("customerId") int customerId) throws Exception {
        var errorMessage = check(customerId, programId);
        if (errorMessage != null) throw errorMessage;

        return ResponseEntity.ok().body(reviewDAO.get(customerId, programId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getReviewById(@PathVariable("id") int id) {
        if (!reviewDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.REVIEW,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        return ResponseEntity.ok().body(reviewDAO.getById(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteReview(@PathVariable("id") int id) {
        if (!reviewDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.REVIEW,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        reviewDAO.delete(id);
        return ResponseEntity.ok().build();
    }

    private ResponseStatusException check(int customerId, int programId) {
        if (!customerDAO.exists(customerId))
            return new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CUSTOMER,
                            Message.Identifier.ID,
                            customerId,
                            Message.Status.NOT_FOUND
                    )
            );

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

        return null;
    }

}

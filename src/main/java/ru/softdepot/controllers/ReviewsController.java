package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.Messages.Message;
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
            if (errorMessage != null) return errorMessage;

            if (reviewDAO.exists(review.getCustomerId(), review.getProgramId()))
                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .body(Message.build(
                                Message.Entity.review,
                                Message.Identifier.id,
                                String.format("id %s покупателя и id %s товара",
                                        review.getCustomerId(),
                                        review.getProgramId()),
                                Message.Status.alreadyExists
                        ));

            reviewDAO.add(review);
            return ResponseEntity.ok().build();
        }
    }

    @PatchMapping("/edit")
    public ResponseEntity<?> editReview(@RequestBody Review review,
                                        BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            var errorMessage = check(review.getCustomerId(), review.getProgramId());
            if (errorMessage != null) return errorMessage;

            reviewDAO.update(review);
            return ResponseEntity.ok().build();
        }
    }

    @GetMapping(params = {"programId"})
    public ResponseEntity<?> getReviewsForProgram(@RequestParam("programId") int programId) {
        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            programId,
                            Message.Status.notFound
                    ));

        return ResponseEntity.ok().body(reviewDAO.getAllAboutProgram(programId));
    }

    @GetMapping(params = {"customerId"})
    public ResponseEntity<?> getReviewsOfCustomer(@RequestParam("customerId") int customerId) {
        if (!customerDAO.exists(customerId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.customer,
                            Message.Identifier.id,
                            customerId,
                            Message.Status.notFound
                    ));

        return ResponseEntity.ok().body(reviewDAO.getAllByCustomer(customerId));
    }

    @GetMapping(params = {"programId", "customerId"})
    public ResponseEntity<?> getCustomersReviewsOfProgram(@RequestParam("programId") int programId,
                                                          @RequestParam("customerId") int customerId) throws Exception {
        var errorMessage = check(customerId, programId);
        if (errorMessage != null) return errorMessage;

        return ResponseEntity.ok().body(reviewDAO.get(customerId, programId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getReviewById(@PathVariable("id") int id) {
        if (!reviewDAO.exists(id))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.review,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));

        return ResponseEntity.ok().body(reviewDAO.getById(id));
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteReview(@PathVariable("id") int id) {
        if (!reviewDAO.exists(id))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.review,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));
        reviewDAO.delete(id);
        return ResponseEntity.ok().build();
    }

    private ResponseEntity<?> check(int customerId, int programId) {
        if (!customerDAO.exists(customerId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.customer,
                            Message.Identifier.id,
                            customerId,
                            Message.Status.notFound
                    ));

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

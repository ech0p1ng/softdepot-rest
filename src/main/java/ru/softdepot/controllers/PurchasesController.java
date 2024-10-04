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
import ru.softdepot.core.dao.PurchaseDAO;
import ru.softdepot.core.models.Customer;
import ru.softdepot.core.models.Purchase;

@RestController
@RequestMapping("/softdepot-api/purchases")
@AllArgsConstructor
public class PurchasesController {
    private final PurchaseDAO purchaseDAO;
    private final ProgramDAO programDAO;
    private final CustomerDAO customerDAO;

    @GetMapping
    public ResponseEntity<?> getAllPurchases() {
        return ResponseEntity.ok().body(purchaseDAO.getAll());
    }

    @GetMapping
    public ResponseEntity<?> getPurchasesByCustomer(@RequestParam("customerId") int customerId) {
        if (!customerDAO.exists(customerId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.customer,
                            Message.Identifier.id,
                            customerId,
                            Message.Status.notFound
                    ));
        Customer customer = null;
        try {
            customer = customerDAO.getById(customerId);
        } catch (Exception e) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(e.getMessage() + "\n\n" + e.getStackTrace());
        }

        var purchases = purchaseDAO.getPurchasesOfCustomer(customer);
        return ResponseEntity.ok().body(purchases);
    }

    @PostMapping("/new")
    public ResponseEntity<?> addPurchase(@RequestBody Purchase purchase,
                                         BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            var errorMessage = check(purchase.getCustomerId(), purchase.getProgramId());
            if (errorMessage != null) return errorMessage;

            purchaseDAO.add(purchase);
            return ResponseEntity.ok().build();
        }
    }

    private ResponseEntity<?> check(int customerId, int programId) {
        if (!customerDAO.exists(customerId)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.customer,
                            Message.Identifier.id,
                            customerId,
                            Message.Status.notFound
                    ));
        }

        if (!programDAO.exists(programId)) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            programId,
                            Message.Status.notFound
                    ));
        }

        if (!purchaseDAO.exists(customerId, programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.purchase,
                            Message.Identifier.id,
                            String.format("%s покупателя и id %s товара",
                                    customerId,
                                    programId),
                            Message.Status.notFound
                    ));
        return null;
    }
}

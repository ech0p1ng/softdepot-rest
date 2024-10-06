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

    @GetMapping(params = {"customerId"})
    public ResponseEntity<?> getPurchasesByCustomer(@RequestParam("customerId") int customerId) throws Exception {
        if (!customerDAO.exists(customerId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.customer,
                            Message.Identifier.id,
                            customerId,
                            Message.Status.notFound
                    ));

        var purchases = purchaseDAO.getPurchasesOfCustomer(customerDAO.getById(customerId));
        return ResponseEntity.ok().body(purchases);
    }

    @GetMapping(params = {"programId"})
    public ResponseEntity<?> getPurchasesOfProgram(@RequestParam("programId") int programId) throws Exception {
        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            programId,
                            Message.Status.notFound
                    ));

        var purchases = purchaseDAO.getPurchasesOfProgram(programDAO.getById(programId));
        return ResponseEntity.ok().body(purchases);
    }

    @GetMapping(params = {"programId", "customerId"})
    public ResponseEntity<?> getPurchaseOfCustomer(@RequestParam("programId") int programId,
                                                   @RequestParam("customerId") int customerId) throws Exception {
        if (!programDAO.exists(programId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.product,
                            Message.Identifier.id,
                            programId,
                            Message.Status.notFound
                    ));

        if (!customerDAO.exists(customerId))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.customer,
                            Message.Identifier.id,
                            customerId,
                            Message.Status.notFound
                    ));

        var purchase = purchaseDAO.getByCustomerAndProgram(
                customerDAO.getById(customerId),
                programDAO.getById(programId));
        return ResponseEntity.ok().body(purchase);
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

    @PatchMapping("/edit/{id}")
    public ResponseEntity<?> editPurchase(@PathVariable("id") int id,
                                          @RequestBody Purchase purchase,
                                          BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            var errorMessage = check(purchase.getCustomerId(), purchase.getProgramId());
            if (errorMessage != null) return errorMessage;

            purchaseDAO.update(purchase);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deletePurchase(@PathVariable("id") int id) {
        if (!purchaseDAO.exists(id))
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.purchase,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));

        purchaseDAO.delete(id);
        return ResponseEntity.ok().build();
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

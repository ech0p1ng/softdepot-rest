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
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CUSTOMER,
                            Message.Identifier.ID,
                            customerId,
                            Message.Status.NOT_FOUND
                    )
            );

        var purchases = purchaseDAO.getPurchasesOfCustomer(customerDAO.getById(customerId));
        return ResponseEntity.ok().body(purchases);
    }

    @GetMapping(params = {"programId"})
    public ResponseEntity<?> getPurchasesOfProgram(@RequestParam("programId") int programId) throws Exception {
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

        var purchases = purchaseDAO.getPurchasesOfProgram(programDAO.getById(programId));
        return ResponseEntity.ok().body(purchases);
    }

    @GetMapping(params = {"programId", "customerId"})
    public ResponseEntity<?> getPurchaseOfCustomer(@RequestParam("programId") int programId,
                                                   @RequestParam("customerId") int customerId) throws Exception {
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
            if (errorMessage != null) throw errorMessage;

            purchaseDAO.add(purchase);
            return ResponseEntity.ok().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPurchaseById(@PathVariable("id") int id) {
        if (!purchaseDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PURCHASE,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        var purchase = purchaseDAO.getById(id);

        var errorMessage = check(purchase.getCustomerId(), purchase.getProgramId());
        if (errorMessage != null) throw errorMessage;

        return ResponseEntity.ok().body(purchase);
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> editPurchase(@RequestBody Purchase purchase,
                                          @PathVariable("id") int id,
                                          BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!purchaseDAO.exists(id))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.PURCHASE,
                                Message.Identifier.ID,
                                id,
                                Message.Status.NOT_FOUND
                        )
                );

            var errorMessage = check(purchase.getCustomerId(), purchase.getProgramId());
            if (errorMessage != null) throw errorMessage;

            purchaseDAO.update(purchase);
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePurchase(@PathVariable("id") int id) {
        if (!purchaseDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PURCHASE,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        purchaseDAO.delete(id);
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

        if (!purchaseDAO.exists(customerId, programId))
            return new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PURCHASE,
                            Message.Identifier.ID,
                            String.format("%s покупателя и id %s товара",
                                    customerId,
                                    programId
                            ),
                            Message.Status.NOT_FOUND
                    )
            );
        return null;
    }
}

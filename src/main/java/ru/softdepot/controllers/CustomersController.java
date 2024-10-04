package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.Messages.Message;
import ru.softdepot.core.dao.CustomerDAO;
import ru.softdepot.core.models.Customer;

@RestController
@RequestMapping("softdepot-api/customers")
@AllArgsConstructor
public class CustomersController {

    private final CustomerDAO customerDAO;

    @PostMapping("/new")
    public ResponseEntity<?> addNewCustomer(@RequestBody Customer customer,
                                            BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (customerDAO.exists(customer.getEmail())) {
                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .body(Message.build(
                                Message.Entity.customer,
                                Message.Identifier.email,
                                customer.getEmail(),
                                Message.Status.alreadyExists
                        ));
            } else {
                try {
                    customerDAO.add(customer);
                } catch (Exception e) {
                    return ResponseEntity
                            .badRequest()
                            .body(e.getMessage() + "\n\n" + e.getStackTrace());
                }
                return ResponseEntity.ok().build();
            }
        }
    }

    @PatchMapping("/edit")
    public ResponseEntity<?> editCustomer(@RequestBody Customer customer,
                                          BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (customerDAO.exists(customer.getId())) {
                customerDAO.update(customer);
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(Message.build(
                                Message.Entity.customer,
                                Message.Identifier.id,
                                customer.getId(),
                                Message.Status.notFound
                        ));
            }
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteCustomer(@PathVariable int id) {
        if (customerDAO.exists(id)) {
            customerDAO.delete(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(Message.build(
                        Message.Entity.customer,
                        Message.Identifier.id,
                        id,
                        Message.Status.notFound
                ));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getCustomer(@PathVariable int id) {
        try {
            Customer admin = customerDAO.getById(id);
            return ResponseEntity.ok().body(admin);
        } catch (Exception e) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.customer,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));
        }
    }

    @GetMapping
    public ResponseEntity<?> getAllCustomers() {
        var admins = customerDAO.getAll();
        return ResponseEntity.ok().body(admins);
    }


}

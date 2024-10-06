package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
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
                                            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (customerDAO.exists(customer.getEmail())) {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.CUSTOMER,
                                Message.Identifier.EMAIL,
                                customer.getEmail(),
                                Message.Status.ALREADY_EXISTS
                        )
                );
            } else {
                customerDAO.add(customer);
                return ResponseEntity.ok().build();
            }
        }
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> editCustomer(@RequestBody Customer customer,
                                          @PathVariable("id") int id,
                                          BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (customerDAO.exists(id)) {
                customerDAO.update(customer);
                return ResponseEntity.ok().build();
            } else {
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.CUSTOMER,
                                Message.Identifier.ID,
                                customer.getId(),
                                Message.Status.NOT_FOUND
                        )
                );
            }
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCustomer(@PathVariable("id") int id) {
        if (customerDAO.exists(id)) {
            customerDAO.delete(id);
            return ResponseEntity.ok().build();
        }
        throw new ResponseStatusException(
                HttpStatus.NOT_FOUND,
                Message.build(
                        Message.Entity.CUSTOMER,
                        Message.Identifier.ID,
                        id,
                        Message.Status.NOT_FOUND
                )
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getCustomer(@PathVariable("id") int id) throws Exception {
        return ResponseEntity.ok().body(customerDAO.getById(id));
    }

    @GetMapping
    public ResponseEntity<?> getAllCustomers() {
        return ResponseEntity.ok().body(customerDAO.getAll());
    }
}

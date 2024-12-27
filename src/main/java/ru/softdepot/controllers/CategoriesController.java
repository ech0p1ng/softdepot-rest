package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.messages.Message;
import ru.softdepot.core.dao.CategoryDAO;
import ru.softdepot.core.models.Category;

@RestController
@RequestMapping("softdepot-api/categories")
@AllArgsConstructor
public class CategoriesController {
    private final CategoryDAO categoryDAO;

    @GetMapping
    public ResponseEntity<?> getAllCategories(@RequestParam(required = false, name = "sortBy") String sortBy) {
        if (sortBy != null) {
            var a = sortBy == "name";
            var b = sortBy.equals("name");

            if (sortBy.equals("name")) {
                return ResponseEntity.ok().body(categoryDAO.getAll(CategoryDAO.Sort.NAME));
            }
        }
        return ResponseEntity.ok().body(categoryDAO.getAll(CategoryDAO.Sort.DEFAULT));
    }

    @PostMapping("/new")
    public ResponseEntity<?> addCategory(@RequestBody Category category,
                                         BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!categoryDAO.exists(category.getName())) {
                categoryDAO.add(category);
                return ResponseEntity.ok().build();
            } else {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.CATEGORY,
                                Message.Identifier.NAME,
                                category.getName(),
                                Message.Status.ALREADY_EXISTS
                        )
                );
            }
        }
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> editCategory(@RequestBody Category category,
                                          @PathVariable("id") int id,
                                          BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (categoryDAO.exists(id)) {
                categoryDAO.update(category);
                return ResponseEntity.ok().build();
            } else {
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.CATEGORY,
                                Message.Identifier.NAME,
                                category.getName(),
                                Message.Status.NOT_FOUND
                        )
                );
            }
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCategory(@PathVariable("id") int id) {
        if (categoryDAO.exists(id)) {
            categoryDAO.delete(id);
            return ResponseEntity.ok().build();
        } else {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CATEGORY,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getCategory(@PathVariable("id") int id) {
        if (categoryDAO.exists(id)) {
            var category = categoryDAO.getById(id);
            return ResponseEntity.ok().body(category);
        } else {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.CATEGORY,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );
        }
    }
}

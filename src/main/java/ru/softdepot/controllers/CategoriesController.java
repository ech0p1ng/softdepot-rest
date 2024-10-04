package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.softdepot.Messages.Message;
import ru.softdepot.core.dao.CategoryDAO;
import ru.softdepot.core.models.Category;

import java.util.List;

@RestController
@RequestMapping("softdepot-api/categories")
@AllArgsConstructor
public class CategoriesController {
    private final CategoryDAO categoryDAO;

    @GetMapping
    public ResponseEntity<?> getAllCategories() {
        List<Category> categories = categoryDAO.getAll();
        return ResponseEntity.ok().body(categories);
    }

    @PostMapping("/new")
    public ResponseEntity<?> addCategory(@RequestBody Category category,
                                         BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            try {
                if (!categoryDAO.exists(category.getName())) {
                    categoryDAO.add(category);
                    return ResponseEntity.ok().build();
                } else {
                    return ResponseEntity
                            .status(HttpStatus.BAD_REQUEST)
                            .body(Message.build(
                                    Message.Entity.category,
                                    Message.Identifier.name,
                                    category.getName(),
                                    Message.Status.alreadyExists
                            ));
                }
            } catch (Exception e) {
                return ResponseEntity
                        .badRequest()
                        .body(e.getMessage() + "\n\n" + e.getStackTrace());
            }
        }
    }

    @PatchMapping("/edit")
    public ResponseEntity<?> editCategory(@RequestBody Category category,
                                          BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!categoryDAO.exists(category.getName())) {
                categoryDAO.update(category);
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .body(Message.build(
                                Message.Entity.category,
                                Message.Identifier.name,
                                category.getName(),
                                Message.Status.alreadyExists
                        ));
            }
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteCategory(@PathVariable("id") int id) {
        if (categoryDAO.exists(id)) {
            categoryDAO.delete(id);
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.category,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getCategory(@PathVariable("id") int id) {
        if (categoryDAO.exists(id)) {
            var category = categoryDAO.getById(id);
            return ResponseEntity.ok().body(category);
        } else {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Message.build(
                            Message.Entity.category,
                            Message.Identifier.id,
                            id,
                            Message.Status.notFound
                    ));
        }
    }

//    @GetMapping("/{name}")
//    public ResponseEntity<?> getCategory(@PathVariable("name") String name) throws BindException {
//        var category = categoryDAO.getByName(name);
//        return ResponseEntity.ok().body(category);
//    }

}

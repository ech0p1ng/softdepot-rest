package ru.softdepot.controllers;

import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
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
                    return ResponseEntity.notFound().build();
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
                return ResponseEntity.notFound().build();
            }
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteCategory(@PathVariable("id") int id) {
        if (categoryDAO.exists(id)) {
            categoryDAO.delete(id);
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getCategory(@PathVariable("id") int id) {
        var category = categoryDAO.getById(id);
        return ResponseEntity.ok().body(category);
    }

//    @GetMapping("/{name}")
//    public ResponseEntity<?> getCategory(@PathVariable("name") String name) throws BindException {
//        var category = categoryDAO.getByName(name);
//        return ResponseEntity.ok().body(category);
//    }

}

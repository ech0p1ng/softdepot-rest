package ru.softdepot.controllers;

import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import ru.softdepot.FileStorageService;
import ru.softdepot.core.dao.*;
import ru.softdepot.core.models.Customer;
import ru.softdepot.core.models.Program;
import ru.softdepot.core.models.User;
import ru.softdepot.messages.Message;
import ru.softdepot.requestBodies.ProgramRequestBody;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("softdepot-api/products")
public class ProductsController {
    private final ProgramDAO programDAO;
    private final DeveloperDAO developerDAO;
    private final CategoryDAO categoryDAO;
    private final UserDAO userDAO;
    private final CustomerDAO customerDAO;
    private final ReviewDAO reviewDAO;
    private final FileStorageService fileStorageService;


    @GetMapping("/{id}")
    public ResponseEntity<?> findProgram(@PathVariable("id") Integer id) throws Exception {
        if (!programDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        var user = UsersController.getCurrentUser(userDAO);
        if (user != null) {
            if (user.getUserType() == User.Type.Customer) {
                var program = programDAO.getById(id);
                checkProgram((Customer) user, program);

                return ResponseEntity.ok().body(program);
            }
        }
        return ResponseEntity.ok().body(programDAO.getById(id));
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> updateProgram(@RequestBody ProgramRequestBody programRequestBody,
                                           @PathVariable("id") Integer id,
                                           BindingResult bindingResult) throws BindException {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {
            if (!programDAO.exists(id))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.ID,
                                id,
                                Message.Status.NOT_FOUND
                        )
                );

            if (!developerDAO.exists(programRequestBody.getDeveloperId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.DEVELOPER,
                                Message.Identifier.ID,
                                programRequestBody.getDeveloperId(),
                                Message.Status.NOT_FOUND
                        )
                );

            var categories = programRequestBody.getCategories();

            for (var category : categories) {
                if (!categoryDAO.exists(category.getId()))
                    throw new ResponseStatusException(
                            HttpStatus.NOT_FOUND,
                            Message.build(
                                    Message.Entity.CATEGORY,
                                    Message.Identifier.ID,
                                    category.getId(),
                                    Message.Status.NOT_FOUND
                            )
                    );

            }

            programDAO.update(programRequestBody.convertToProgram());
            return ResponseEntity.ok().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProgram(@PathVariable("id") Integer id) {
        if (!programDAO.exists(id))
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.ID,
                            id,
                            Message.Status.NOT_FOUND
                    )
            );

        Program program = null;
        try {
            program = programDAO.getById(id);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        var path = program.getFilesPath(fileStorageService.getMediaUploadDir());
        File folder = new File(path.toString());
        if (folder.exists()) {
            try {
                FileUtils.deleteDirectory(folder);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        programDAO.delete(id);
        return ResponseEntity.ok().build();
    }

    @PostMapping(value = "/new", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> addNewProgram(
            @RequestParam("developerId") int developerId,
            @RequestParam("name") String name,
            @RequestParam("shortDescription") String shortDescription,
            @RequestParam("fullDescription") String fullDescription,
            @RequestParam("price") double price,
            @RequestPart("categories") String categoriesJson,
            @RequestParam("logo") MultipartFile logo,
            @RequestParam("screenshots") List<MultipartFile> screenshots
    ) throws IOException {

        ProgramRequestBody programRequestBody = new ProgramRequestBody(
                developerId,
                name,
                shortDescription,
                fullDescription,
                price,
                categoriesJson,
                logo,
                screenshots
        );

        if (!developerDAO.exists(programRequestBody.getDeveloperId())) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    Message.build(
                            Message.Entity.DEVELOPER,
                            Message.Identifier.ID,
                            programRequestBody.getDeveloperId(),
                            Message.Status.NOT_FOUND
                    )
            );
        }

        var categories = programRequestBody.getCategories();

        for (var category : categories) {
            if (!categoryDAO.exists(category.getId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.CATEGORY,
                                Message.Identifier.ID,
                                category.getId(),
                                Message.Status.NOT_FOUND
                        )
                );
        }

        if (programDAO.exists(programRequestBody.getName(), programRequestBody.getDeveloperId())) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    Message.build(
                            Message.Entity.PRODUCT,
                            Message.Identifier.NAME,
                            String.format(
                                    "%s от разработчика с id %s",
                                    programRequestBody.getName(),
                                    programRequestBody.getDeveloperId()),
                            Message.Status.ALREADY_EXISTS
                    )
            );
        }

        int minCategoriesAmount = 3;
        if (categories.size() < minCategoriesAmount) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "У программы должно быть как минимум " + minCategoriesAmount + " категории"
            );
        }

        int maxScreenshotsAmount = 10;
        if (screenshots.size() > maxScreenshotsAmount) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "У программы должно быть максимум " + maxScreenshotsAmount + " скриншотов"
            );
        }


        var program = programRequestBody.convertToProgram();
        int id = programDAO.add(program);

        //Сохранение лого и скриншотов на сервер
        programDAO.addMedia(fileStorageService, id, program, logo, screenshots);

        return ResponseEntity.ok().build();
    }

    /*
    @PostMapping(value = "/new", consumes = "multipart/form-data")
    public ResponseEntity<?> addNewProgram(@RequestBody ProgramRequestBody programRequestBody,
                                           BindingResult bindingResult,
                                           UriComponentsBuilder uriComponentsBuilder) throws Exception {
        if (bindingResult.hasErrors()) {
            if (bindingResult instanceof BindException exception) throw exception;
            else throw new BindException(bindingResult);
        } else {

//            if (!programDAO.exists(program.getId()))
//                throw new ResponseStatusException(
//                        HttpStatus.NOT_FOUND,
//                        Message.build(
//                                Message.Entity.PRODUCT,
//                                Message.Identifier.ID,
//                                program.getId(),
//                                Message.Status.NOT_FOUND
//                        )
//                );

            if (!developerDAO.exists(programRequestBody.getDeveloperId()))
                throw new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        Message.build(
                                Message.Entity.DEVELOPER,
                                Message.Identifier.ID,
                                programRequestBody.getDeveloperId(),
                                Message.Status.NOT_FOUND
                        )
                );

            var categories = programRequestBody.getCategories();

            for (var category : categories) {
                if (!categoryDAO.exists(category.getId()))
                    throw new ResponseStatusException(
                            HttpStatus.NOT_FOUND,
                            Message.build(
                                    Message.Entity.CATEGORY,
                                    Message.Identifier.ID,
                                    category.getId(),
                                    Message.Status.NOT_FOUND
                            )
                    );
            }

            if (!programDAO.exists(programRequestBody.getName(), programRequestBody.getDeveloperId()))
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        Message.build(
                                Message.Entity.PRODUCT,
                                Message.Identifier.NAME,
                                String.format(
                                        "%s от разработчика с id %s",
                                        programRequestBody.getName(),
                                        programRequestBody.getDeveloperId()),
                                Message.Status.ALREADY_EXISTS
                        )
                );

            programDAO.add(programRequestBody.convertToProgram());

            return ResponseEntity.ok().build();
        }
    }
*/
    @GetMapping
    public ResponseEntity<?> getPrograms(
            @RequestParam(name = "developerId", required = false) String developerId) {


        List<Program> allPrograms;

        if (developerId != null) {
            int devId = Integer.parseInt(developerId);
            try {
                allPrograms = developerDAO.getPrograms(devId);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        } else {
            allPrograms = programDAO.getAll();
        }

        var user = UsersController.getCurrentUser(userDAO);
        if (user != null) {
            if (user.getUserType() == User.Type.Customer) {
                for (int i = 0; i < allPrograms.size(); i++) {
                    var program = allPrograms.get(i);
//                    program.setIsInCart(programDAO.isInCart(program, (Customer) user));
//                    program.setIsPurchased(programDAO.isPurchased(program, (Customer) user));
                    checkProgram((Customer) user, program);
                    allPrograms.set(i, program);
                }

                return ResponseEntity.ok().body(allPrograms);
            }
        }
        return ResponseEntity.ok().body(programDAO.getAll());
    }

    @GetMapping("/recommendations")
    public ResponseEntity<?> getRecommendations(
            @RequestParam("customerId") Integer customerId,
            @RequestParam(value = "minEstimation", required = false) Double minEstimation,
            @RequestParam(value = "maxPrice", required = false) Double maxPrice) {
        Customer customer;
        try {
            customer = customerDAO.getById(customerId);
        } catch (Exception e) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    ru.softdepot.messages.Message.build(
                            Message.Entity.CUSTOMER,
                            Message.Identifier.ID,
                            customerId,
                            Message.Status.NOT_FOUND
                    )
            );
        }

        if (minEstimation == null) minEstimation = 0.0;
        if (maxPrice == null) maxPrice = Double.MAX_VALUE;

        List<Program> recommendations;

        try {
            recommendations = programDAO.getRecommendations(customer, minEstimation, maxPrice);
            for (int i = 0; i < recommendations.size(); i++) {
                var program = recommendations.get(i);
                recommendations.set(i, checkProgram(customer, program));
            }

            return ResponseEntity.ok().body(recommendations);
        } catch (Exception e) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    e.getMessage()
            );
        }
    }

    private Program checkProgram(Customer customer, Program program) {
        //Проверка корзины
        program.setIsInCart(programDAO.isInCart(program, customer));
        program.setIsPurchased(programDAO.isPurchased(program, customer));

        //Проверка отзыва
        try {
            var review = customerDAO.getReview(customer, program);
            program.setHasReview(review != null);
        } catch (Exception e) {
        }

        //Проверка приобретения программы
        program.setIsPurchased(customerDAO.hasPurchasedProgram(customer, program));
        return program;
    }
}
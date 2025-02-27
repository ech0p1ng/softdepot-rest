package ru.softdepot.requestBodies;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.web.multipart.MultipartFile;
import ru.softdepot.core.models.Category;
import ru.softdepot.core.models.Program;

import java.math.BigDecimal;
import java.util.List;

public class ProgramRequestBody {
    private int developerId;
    private String name;
    private String shortDescription;
    private String fullDescription;
    private double price;
    private String categoriesJson;
    private MultipartFile logo;
    private List<MultipartFile> screenshots;

    private ObjectMapper objectMapper = new ObjectMapper();
    private List<Category> categories;

    public ProgramRequestBody(int developerId, String name, String shortDescription,
                              String fullDescription, Double price, String categoriesJson,
                              MultipartFile logo, List<MultipartFile> screenshots) {

        this.developerId = developerId;
        this.name = name;
        this.shortDescription = shortDescription;
        this.fullDescription = fullDescription;
        this.price = price;
        try {
            categories = objectMapper.readValue(categoriesJson, new TypeReference<List<Category>>() {});
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        this.logo = logo;
        this.screenshots = screenshots;
    }

    public Program convertToProgram() {
        Program program = new Program();
        program.setCategories(categories);
        program.setDeveloperId(Math.toIntExact(developerId));
        program.setName(name);
        program.setShortDescription(shortDescription);
        program.setFullDescription(fullDescription);
        program.setPrice(BigDecimal.valueOf(price));
        program.setLogo(logo);
        program.setScreenshots(screenshots);
        return program;
    }

    public int getDeveloperId() {
        return developerId;
    }

    public String getName() {
        return name;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public String getFullDescription() {
        return fullDescription;
    }

    public Double getPrice() {
        return price;
    }

    public List<Category> getCategories() {
        return categories;
    }

    public MultipartFile getLogo() {
        return logo;
    }

    public List<MultipartFile> getScreenshots() {
        return screenshots;
    }

    public void setDeveloperId(int developerId) {
        this.developerId = developerId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public void setFullDescription(String fullDescription) {
        this.fullDescription = fullDescription;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public void setCategories(List<Category> categories) {
        this.categories = categories;
    }

    public void setLogo(MultipartFile logo) {
        this.logo = logo;
    }

    public void setScreenshots(List<MultipartFile> screenshots) {
        this.screenshots = screenshots;
    }
}
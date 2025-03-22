package ru.softdepot.core.models;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ru.softdepot.FileStorageService;

import java.io.File;
import java.math.BigDecimal;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Component
public class Program {
    @Autowired
    FileStorageService fileStorageService;
    private static String mediaUploadDir;
    private int id;
    private String name;
    private BigDecimal price;
    private String fullDescription;
    private int developerId;
    private String shortDescription;
    private List<Category> categories;
    private float averageEstimation;
    private String filesPath;
    private String nameForPath;
    private MultipartFile winInstaller;
    private MultipartFile linuxInstaller;
    private MultipartFile macosInstaller;
    private MultipartFile headerImg;
    private List<MultipartFile> screenshots;
    private MultipartFile logo;
    private String headerUrl;
    private boolean isInCart = false;
    private boolean hasReview = false;
    private boolean isPurchased = false;
    private String pageUrl;
    private String logoUrl;
    private List<String> screenshotsUrls;

    public Program(int id, String name, BigDecimal price, String fullDescription,
                   int developerId, String shortDescription, List<Category> categories, String logoUrl, String[] screenshotsUrls) {
        this.id = id;
        this.price = price;
        this.fullDescription = fullDescription;
        this.developerId = developerId;
        this.shortDescription = shortDescription;
        this.categories = categories;
        this.logoUrl = logoUrl;
        if (screenshotsUrls != null) {
            this.screenshotsUrls = Arrays.asList(screenshotsUrls);
        }
        setName(name);
        setPageUrl();
    }

    public Program(String name, BigDecimal price, String fullDescription,
                   int developerId, String shortDescription, List<Category> categories) {
        this.price = price;
        this.fullDescription = fullDescription;
        this.developerId = developerId;
        this.shortDescription = shortDescription;
        this.categories = categories;
        setName(name);
        setPageUrl();
    }

    public Program(String name, BigDecimal price, String description,
                   int developerId, String shortDescription) {
        this.price = price;
        this.fullDescription = description;
        this.developerId = developerId;
        this.shortDescription = shortDescription;
        setName(name);
        setPageUrl();
    }

    public Program(int id) {
        this.id = id;
    }

    public Program() {
    }

    public Program(String name, String shortDescription, String fullDescription,
                   BigDecimal price, MultipartFile logo, MultipartFile winInstaller,
                   MultipartFile linuxInstaller, MultipartFile macosInstaller,
                   MultipartFile headerImg, List<MultipartFile> screenshots) {
        setName(name);
        setShortDescription(shortDescription);
        setFullDescription(fullDescription);
        setPrice(price);
        setLogo(logo);
        setWinInstaller(winInstaller);
        setLinuxInstaller(linuxInstaller);
        setMacosInstaller(macosInstaller);
        setHeaderImg(headerImg);
        setScreenshots(screenshots);
        setPageUrl();
    }


    public String getPageUrl() {
        return pageUrl;
    }

    public void setPageUrl() {
        this.pageUrl = "/programs/" + this.id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        this.nameForPath = name.replaceAll(" ", "_");
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getPriceAsString() {
        if (getPrice().compareTo(BigDecimal.ZERO) > 0) {
            String priceStr = getPrice().toString() + " руб.";
            priceStr = priceStr.replace(".00", "");
            return priceStr;
        } else {
            return "Бесплатно";
        }
    }

    public String getFullDescription() {
        return fullDescription;
    }

    public void setFullDescription(String fullDescription) {
        this.fullDescription = fullDescription;
    }

    public int getDeveloperId() {
        return developerId;
    }

    public void setDeveloperId(int developerId) {
        this.developerId = developerId;
    }

    public float getAverageEstimation() {
        return averageEstimation;
    }

    public void setAverageEstimation(float averageEstimation) {
        this.averageEstimation = averageEstimation;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public List<Category> getCategories() {
        return categories;
    }

    public void setCategories(List<Category> categories) {
        this.categories = categories;
    }

    public void setTags(List<Category> categories) {
        this.categories = categories;
    }

    public String getTagsAsString() {
        List<String> tagNameList = new ArrayList<>();
        if (categories == null)
            return "";
        for (Category category : categories) {
            tagNameList.add(category.getName());
        }

        return String.join(", ", tagNameList);
    }

    public String getNameForPath() {
        return nameForPath;
    }

    public String getInstallerWindowsUrl(String mediaUploadDir) {
        String path = getFilesPath(mediaUploadDir) + "/installers/win";

        File dir = new File(path);
        if (dir.isDirectory()) {
            File[] files = dir.listFiles();
            return files[0].getAbsolutePath();
        }
        return null;
    }

    public String getInstallerLinuxUrl(String mediaUploadDir) {
        String path = getFilesPath(mediaUploadDir) + "/installers/linux";

        File dir = new File(path);
        if (dir.isDirectory()) {
            File[] files = dir.listFiles();
            return files[0].getAbsolutePath();
        }
        return null;
    }

    public String getInstallerMacosUrl(String mediaUploadDir) {
        String path = getFilesPath(mediaUploadDir) + "/installers/macos";

        File dir = new File(path);
        if (dir.isDirectory()) {
            File[] files = dir.listFiles();
            return files[0].getAbsolutePath();
        }
        return null;
    }

    public Path getFilesPath(String mediaUploadDir) {
        return Paths.get(
                mediaUploadDir,
                "program",
                String.valueOf(getId())
        );
    }

    public MultipartFile getWinInstaller() {
        return winInstaller;
    }

    public void setWinInstaller(MultipartFile winInstaller) {
        this.winInstaller = winInstaller;
    }

    public MultipartFile getLinuxInstaller() {
        return linuxInstaller;
    }

    public void setLinuxInstaller(MultipartFile linuxInstaller) {
        this.linuxInstaller = linuxInstaller;
    }

    public MultipartFile getMacosInstaller() {
        return macosInstaller;
    }

    public void setMacosInstaller(MultipartFile macosInstaller) {
        this.macosInstaller = macosInstaller;
    }

    public MultipartFile getHeaderImg() {
        return headerImg;
    }

    public void setHeaderImg(MultipartFile headerImg) {
        this.headerImg = headerImg;
    }

    public List<MultipartFile> getScreenshots() {
        return screenshots;
    }

    public void setScreenshots(List<MultipartFile> screenshots) {
        this.screenshots = screenshots;
    }

    public MultipartFile getLogo() {
        return logo;
    }

    public void setLogo(MultipartFile logo) {
        this.logo = logo;
    }

    public void setHeaderUrl() {
        this.headerUrl = "/program/content/" + getId() + "/header.jpg";
    }

    public String getHeaderUrl() {
//        return headerUrl;
        return getLogoUrl();
    }

    public boolean getIsInCart() {
        return isInCart;
    }

    public void setIsInCart(boolean isInCart) {
        this.isInCart = isInCart;
    }

    public boolean getIsPurchased() {
        return isPurchased;
    }

    public void setIsPurchased(boolean isPurchased) {
        this.isPurchased = isPurchased;
    }

    public boolean getHasReview() {
        return hasReview;
    }

    public void setHasReview(boolean hasReview) {
        this.hasReview = hasReview;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }

    public List<String> getScreenshotsUrls() {
        return screenshotsUrls;
    }

    public void setScreenshotsUrls(List<String> screenshotsUrls) {
        this.screenshotsUrls = screenshotsUrls;
    }

    @Override
    public String toString() {
        StringBuilder categoriesString = new StringBuilder();
        boolean isFirst = true;
        for (var category : this.categories) {
            if (isFirst) {
                categoriesString.append(category.toString());
            } else {
                categoriesString.append(", ").append(category.toString());
            }
            isFirst = false;
        }

        return "Program [id=" + this.id + ", name=" + this.name + ", pageUrl=" + this.pageUrl + ", categories=[" + categoriesString + "]]";
    }

    @Override
    public boolean equals(Object obj) {
        return this.id == ((Program) obj).id && this.name.equals(((Program) obj).name);
    }

    public static String getMediaUploadDir() {
        return mediaUploadDir;
    }

    public static void setMediaUploadDir(String mediaUploadDir) {
        Program.mediaUploadDir = mediaUploadDir;
        System.out.println(Program.mediaUploadDir);
    }
}

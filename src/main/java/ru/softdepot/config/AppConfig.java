package ru.softdepot.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {
    @Value("${file.upload-dir}")
    private String fileUploadPath;

    public String getFileUploadPath() {
        return fileUploadPath;
    }
}

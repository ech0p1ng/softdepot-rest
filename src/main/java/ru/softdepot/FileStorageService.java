package ru.softdepot;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileStorageService {
    @Value("${app.media.upload.dir}")
    private String mediaUploadDir;

    public Path saveFile(MultipartFile file, Path path) throws IOException {
        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
        Path filePath = Paths.get(
                path.toString(),
                fileName
        );
        Path directoryPath = filePath.getParent();
        if (!Files.exists(directoryPath)) {
            Files.createDirectories(directoryPath);
        }
        Files.copy(file.getInputStream(), filePath);
        return filePath;
    }

    public String getMediaUploadDir() {
        return mediaUploadDir;
    }

    public String convertToPublicFilePath(Path localFilePath) {
        var mediaUploadPath = Path.of(mediaUploadDir);
        return localFilePath
                .toString()
                .replace(mediaUploadPath.toString(), "/uploads")
                .replace("\\", "/");
    }

    public Path convertToPrivateFilePath(String publicFilePath) {
        var mediaUploadPath = Path.of(mediaUploadDir);
        var strPath = publicFilePath.toString().replace("/uploads", mediaUploadPath.toString());
        return Paths.get(strPath);
    }
}

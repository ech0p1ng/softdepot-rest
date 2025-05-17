package ru.softdepot.core.dao;
import io.github.cdimascio.dotenv.Dotenv;

import org.json.JSONObject;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.time.*;


public class DataBase {
    private static String url = "jdbc:postgresql://localhost:5432/softdepot";

    private static String user = "postgres";
    private static String password = "postgres";

    private static String customerRole = "customer_role";
    private static String customerPassword = "at7DcsAixTk4Eqs7zdp3";

    private static String developerRole = "developer_role";
    private static String developerPassword = "32BItzvBNem4vEaXxjBb";

    private static String administratorRole = "administrator_role";
    private static String administratorPassword = "9QrlLHkwMJah3hNoMRlW";

    private static String unregisteredRole = "unregistered_role";
    private static String unregisteredUserPassword = "WqQMglB97jPxKw7TCiFc";

    private static ZoneOffset zoneOffset = ZoneOffset.UTC;

    public DataBase() {
        Dotenv dotenv = Dotenv.load();
        String host = dotenv.get("POSTGRES_HOST");
        String port = dotenv.get("POSTGRES_PORT");
        String db = dotenv.get("POSTGRES_DB");
        String user = dotenv.get("POSTGRES_USER");
        String password = dotenv.get("POSTGRES_PASSWORD");
        StringBuilder urlsb = new StringBuilder();
        urlsb.append("jdbc:postgresql://")
                .append(host).append(":").append(port)
                .append("/").append(db);
        DataBase.url = urlsb.toString();
        DataBase.user = user;
        DataBase.password = password;

    }

    public static Timestamp convertToTimestamp(OffsetDateTime offsetDateTime) {
        Instant nowInstant = offsetDateTime.toInstant();
        ZonedDateTime nowZonedDateTime = ZonedDateTime.ofInstant(nowInstant, zoneOffset); // преобразуем Instant в ZonedDateTime в часовом поясе UTC
        Timestamp timestamp = Timestamp.valueOf(nowZonedDateTime.toLocalDateTime()); // преобразуем ZonedDateTime в Timestamp
        return timestamp;
    }

    //я 2.5 часа пыхтел над этой парашей т_т
    public static OffsetDateTime convertToDateTime(Timestamp timestamp) {
        Instant nowInstant = timestamp.toInstant();
        OffsetDateTime offsetDateTime = OffsetDateTime.ofInstant(nowInstant, zoneOffset);
        //даже не спрашивайте что это, оно просто работает...
        long zoneOffsetInSeconds = ZoneId.systemDefault().getRules().getOffset(nowInstant).getTotalSeconds();

        offsetDateTime = offsetDateTime.plusSeconds(zoneOffsetInSeconds);
        return offsetDateTime;
    }

    public static JSONObject serializeToJson() {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("url", url);
        jsonObject.put("customer_name", customerRole);
        jsonObject.put("customer_password", customerPassword);
        jsonObject.put("developer_name", developerRole);
        jsonObject.put("developer_password", developerPassword);
        jsonObject.put("administrator_name", administratorRole);
        jsonObject.put("administrator_password", administratorPassword);
        jsonObject.put("unregistered_user_name", unregisteredRole);
        jsonObject.put("unregistered_user_password", unregisteredUserPassword);
        return jsonObject;
    }

    public static void deserializeFromJson(JSONObject jsonObject) {
        url = jsonObject.getString("url");
        customerRole = jsonObject.getString("customer_name");
        customerPassword = jsonObject.getString("customer_password");
        developerRole = jsonObject.getString("developer_name");
        developerPassword = jsonObject.getString("developer_password");
        administratorRole = jsonObject.getString("administrator_name");
        administratorPassword = jsonObject.getString("administrator_password");
        unregisteredRole = jsonObject.getString("unregistered_user_name");
        unregisteredUserPassword = jsonObject.getString("unregistered_user_password");
    }

    public static String getUrl() {
        return url;
    }

    public static String getUser() {
        return user;
    }

    public static String getPassword() {
        return password;
    }

    public static String getCustomerRole() {
        return customerRole;
    }

    public static String getCustomerPassword() {
        return customerPassword;
    }

    public static String getDeveloperRole() {
        return developerRole;
    }

    public static String getDeveloperPassword() {
        return developerPassword;
    }

    public static String getAdministratorRole() {
        return administratorRole;
    }

    public static String getAdministratorPassword() {
        return administratorPassword;
    }

    public static String getUnregisteredRole() {
        return unregisteredRole;
    }

    public static String getUnregisteredUserPassword() {
        return unregisteredUserPassword;
    }

    public static ZoneOffset getZoneOffset() {
        return zoneOffset;
    }
}
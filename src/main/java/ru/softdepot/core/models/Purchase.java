package ru.softdepot.core.models;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

public class Purchase {
    private int id;
    private OffsetDateTime dateTime;
    private int customerId;
    private int programId;
    private int currencyId;

    private String programName;
    private String programLink;
    private String customerName;
    private String customerLink;

    public Purchase(int id, OffsetDateTime purchaseDate, int customerId, int programId, int currencyid) {
        this.id = id;
        this.dateTime = purchaseDate;
        this.customerId = customerId;
        this.programId = programId;
        this.currencyId = currencyid;
    }

    public Purchase(int id, int customerId, int programId) {
        this.id = id;
        this.dateTime = OffsetDateTime.now();
        this.customerId = customerId;
        this.programId = programId;
    }

    public Purchase(int customerId, int programId) {
        this.dateTime = OffsetDateTime.now();
        this.customerId = customerId;
        this.programId = programId;
    }

    public Purchase() {

    }

    public Purchase(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public OffsetDateTime getDateTime() {
        return dateTime;
    }

    public void setDateTime(OffsetDateTime dateTime) {
        this.dateTime = dateTime;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getProgramId() {
        return programId;
    }

    public void setProgramId(int programId) {
        this.programId = programId;
    }

    public String getProgramName() {
        return programName;
    }

    public void setProgramName(String programName) {
        this.programName = programName;
    }

    public String getProgramLink() {
        return programLink;
    }

    public void setProgramLink(String programLink) {
        this.programLink = programLink;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerLink() {
        return customerLink;
    }

    public void setCustomerLink(String customerLink) {
        this.customerLink = customerLink;
    }

    public String getDateTimeAsString() {
        String day = String.valueOf(dateTime.getDayOfMonth());
        String month = String.valueOf(dateTime.getMonthValue());
        String year = String.valueOf(dateTime.getYear());
        String hour = String.valueOf(dateTime.getHour());
        String minute = String.valueOf(dateTime.getMinute());
        String second = String.valueOf(dateTime.getSecond());
        String millisecond = String.valueOf(dateTime.getNano() / 1000000);

        while (day.length() < 2) day = "0" + day;
        while (month.length() < 2) month = "0" + month;
        while (hour.length() < 2) hour = "0" + hour;
        while (minute.length() < 2) minute = "0" + minute;
        while (second.length() < 2) second = "0" + second;
        while (millisecond.length() < 2) millisecond = "0" + millisecond;

        return String.format("%s.%s.%s %s:%s:%s.%s",
                day, month, year, hour,minute, second, millisecond);

    }

    public int getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(int currencyId) {
        this.currencyId = currencyId;
    }
}

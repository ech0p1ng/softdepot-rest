package ru.softdepot.core.models;

import java.time.OffsetDateTime;

public class Review {
    private int id;
    private Customer customer;
    private Program program;
    private int estimation;
    private String reviewText;
    private OffsetDateTime dateTime;
    private String programName;
    private int customerId;
    private int programId;

    public Review(int id, Customer customer, Program program, int estimation, String reviewText, OffsetDateTime dateTime) {
        this.id = id;
        this.customer = customer;
        this.customer.setPassword(null);
        this.program = program;
        setEstimation(estimation);
        this.reviewText = reviewText;
        this.dateTime = dateTime;
    }

    public Review(int customerId, int programId, int estimation, String reviewText, OffsetDateTime dateTime) {
        this.id = -1;
        this.customer = null;
        this.program = null;
        setEstimation(estimation);
        this.reviewText = reviewText;
        this.dateTime = dateTime;
    }

    public Review(int customerId, int programId, int estimation, String reviewText) {
        this.id = -1;
        this.customer = null;
        this.program = null;
        setEstimation(estimation);
        this.reviewText = reviewText;
        this.dateTime = OffsetDateTime.now();
    }

    public Review() {

    }

    public Review(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Program getProgram() {
        return program;
    }

    public void setProgram(Program program) {
        this.program = program;
    }

    public int getEstimation() {
        return estimation;
    }

    public void setEstimation(int estimation) {
        if (estimation >= 0 && estimation <= 5) {
            this.estimation = estimation;
        }
        else if (estimation > 5) estimation = 5;
        else if (estimation < 0) estimation = 0;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public OffsetDateTime getDateTime() {
        return dateTime;
    }

    public void setDateTime(OffsetDateTime dateTime) {
        this.dateTime = dateTime;
    }

    public String getProgramName() {
        return programName;
    }

    public void setProgramName(String programName) {
        this.programName = programName;
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
}

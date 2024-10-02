package ru.softdepot.core.models;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public class DailyStats {
    private int id;
    private OffsetDateTime date;
    private int programId;
    private float avgEstimation;
    private BigDecimal earnings;
    private int purchasesAmount;
    private int reviewsAmount;

    public DailyStats(int id, OffsetDateTime date, int programId, float avgEstimation, BigDecimal earnings, int purchasesAmount, int reviewsAmount) {
        this.id = id;
        this.date = date;
        this.programId = programId;
        this.avgEstimation = avgEstimation;
        this.earnings = earnings;
        this.purchasesAmount = purchasesAmount;
        this.reviewsAmount = reviewsAmount;
    }

    public DailyStats(int id, OffsetDateTime date, int programId) {
        this.id = id;
        this.date = date;
        this.programId = programId;
    }

    public DailyStats(int id) {
        this.id = id;
    }

    public DailyStats() { }

    public int getId() {
        return id;
    }

    public OffsetDateTime getDate() {
        return date;
    }

    public void setDate(OffsetDateTime date) {
        this.date = date;
    }

    public int getProgramId() {
        return programId;
    }

    public void setProgramId(int programId) {
        this.programId = programId;
    }

    public float getAvgEstimation() {
        return avgEstimation;
    }

    public void setAvgEstimation(float avgEstimation) {
        this.avgEstimation = avgEstimation;
    }

    public BigDecimal getEarnings() {
        return earnings;
    }

    public void setEarnings(BigDecimal earnings) {
        this.earnings = earnings;
    }

    public int getPurchasesAmount() {
        return purchasesAmount;
    }

    public void setPurchasesAmount(int purchasesAmount) {
        this.purchasesAmount = purchasesAmount;
    }

    public int getReviewsAmount() {
        return reviewsAmount;
    }

    public void setReviewsAmount(int reviewsAmount) {
        this.reviewsAmount = reviewsAmount;
    }
}

package ru.softdepot.core.models;

public record Recommendation(Program program, double euclideanDistance) {
    public String toString() {
        return "Recommendation [program=[" + program + "], euclideanDistance=" + euclideanDistance + "]";
    }
}

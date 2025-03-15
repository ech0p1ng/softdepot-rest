package ru.softdepot.core.models;

import java.util.List;

public record Recommendation(Program program, double euclideanDistance, List<Double> degreesOfBelonging) {
    public String toString() {
        return "Recommendation [program=[" + program + "], euclideanDistance=" + euclideanDistance + "]";
    }
}

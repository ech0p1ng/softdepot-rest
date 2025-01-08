package ru.softdepot.core.models;

import java.util.Calendar;
import java.util.List;

public record RecommendationResult(Customer customer, List<Program> allPrograms, List<Recommendation> recommendations, String dateTime) {}

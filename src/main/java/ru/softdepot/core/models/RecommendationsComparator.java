package ru.softdepot.core.models;

import java.util.Comparator;

public class RecommendationsComparator implements Comparator<Recommendation> {

    @Override
    public int compare(Recommendation o1, Recommendation o2) {
        if (o1.euclideanDistance() > o2.euclideanDistance()) {
            if (o1.program().getAverageEstimation() < o2.program().getAverageEstimation()) {
                if (o1.program().getPrice().compareTo(o2.program().getPrice()) < 0) {
                    return 1;
                }
            }
        }

        if (o1.euclideanDistance() == o2.euclideanDistance() &&
                o1.program().getPrice().compareTo(o2.program().getPrice()) == 0 &&
                o1.program().getAverageEstimation() == o2.program().getAverageEstimation()) {
            return 0;
        }

        return -1;
    }
}

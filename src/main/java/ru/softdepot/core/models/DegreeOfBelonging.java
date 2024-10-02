package ru.softdepot.core.models;

public class DegreeOfBelonging {
    private int id;
    private int programId;
    private int tagId;
    private int degreeOfBelongingValue;

    public DegreeOfBelonging(int id, int programId, int tagId, int degreeOfBelongingValue) {
        this.id = id;
        this.programId = programId;
        this.tagId = tagId;
        this.setDegreeOfBelongingValue(degreeOfBelongingValue);
    }

//    public DegreeOfBelonging(int programId, int tagId, float degreeOfBelongingValue) {
//        this.programId = programId;
//        this.tagId = tagId;
//        this.setDegreeOfBelongingValue(degreeOfBelongingValue);
//    }

    public DegreeOfBelonging(int id) {
        this.id = id;
    }

    public DegreeOfBelonging(){}

    public int getId() {
        return id;
    }

    public int getProgramId() {
        return programId;
    }

    public void setProgramId(int programId) {
        this.programId = programId;
    }

    public int getTagId() {
        return tagId;
    }

    public void setTagId(int tagId) {
        this.tagId = tagId;
    }

    public int getDegreeOfBelongingValue() {
        return degreeOfBelongingValue;
    }

    public void setDegreeOfBelongingValue(int degreeValue) {
        if (degreeValue >= 0 && degreeValue <= 10) {
            this.degreeOfBelongingValue = degreeValue;
        }
        else if (degreeValue > 10)
            this.degreeOfBelongingValue = 10;
        else
            this.degreeOfBelongingValue = 0;
    }
}

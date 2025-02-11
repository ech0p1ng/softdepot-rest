class Tag {
    constructor(data = null, id = null, name = null, degreeOfBelonging = null, programId = null) {
        if (id != null) this.id = id;
        if (name != null) this.name = name;
        if (degreeOfBelonging != null) this.degreeOfBelonging = degreeOfBelonging;
        if (programId != null) this.programId = programId;

        if (data != null) {
            this.id = data.id;
            this.name = data.name;
            this.degreeOfBelonging = data.degreeOfBelonging;
            this.programId = data.programId;
        }
    }
}

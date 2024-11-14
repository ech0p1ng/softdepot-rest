class Review {
    constructor(response) {
        this.id = response.id;
        this.customer = new User(response.customer);
        this.program = Program.catalogue.find(program => program.id === response.program.id);
        this.estimation = response.estimation;
        this.reviewText = response.reviewText;
        this.dateTime = response.dateTime;
        this.programName = response.programName;

        this.reviewRow = $(
            '<div class="review">' +
            '    <a class="review-user" href="' + this.customer.pageUrl + '">' +
            '        <img class="review-user-profile-img" src="' + this.customer.profileImgUrl + '" />' +
            '        <span class="review-username">' + this.customer.name + '</span>' +
            '    </a>' +
            '    <br />' +
            '    <span class="review-estimation" style="color: ' + Program.getScoreColor(this.estimation) + '">' + this.estimation + ' / 5</span>' +
            '    <br />' +
            '    <br />' +
            '    <span class="review-text">' + this.reviewText + '</span>' +
            '</div>'
        );
    }

    getReviewRow() {
        return this.reviewRow;
    }
}
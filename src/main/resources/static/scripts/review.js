let STAR_FILL = null;
let STAR_OUTLINE = null;

window.addEventListener('load', function () {
    fetch('/styles/svg/star-fill.svg')
        .then(response => response.text())
        .then(data => {
            STAR_FILL = data;
            console.log(STAR_FILL);
        });
    fetch('/styles/svg/star-outline.svg')
        .then(response => response.text())
        .then(data => {
            STAR_OUTLINE = data;
            console.log(STAR_OUTLINE);
        });
});

class Review {
    constructor(response) {
        this.id = response.id;
        this.customer = new User(response.customer);
        this.program = new Program(response.program);
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
            '    <div class="review-estimation" style="color: ' + Program.getScoreColor(this.estimation) + '"></div>' +
            '    <br />' +
            '    <span class="review-text">' + this.reviewText + '</span>' +
            '</div>'
        );

        this.reviewRowAtUserPage = $(
            '<div class="review">' +
            '    <a href="' + this.program.pageUrl + '" class="review-program" target="_blank" >' +
            '        <img class="review-program-preview" src="' + this.program.headerUrl + '" title="' + this.program.name + '">' +
            '        <span class="review-program-name">'+this.program.name+'</span>'+
            '    </a>' +
            '    <br />' +
            '    <div class="review-estimation" style="color: ' + Program.getScoreColor(this.estimation) + '"></div>' +
            '    <br />' +
            '    <span class="review-text">' + this.reviewText + '</span>' +
            '</div>'
        );

        for (let i = 0; i < this.estimation; i++) {
            this.reviewRow
                .find(".review-estimation")
                .append(STAR_FILL);
            this.reviewRowAtUserPage
                .find(".review-estimation")
                .append(STAR_FILL);
        }
        for (let i = 0; i < 5 - this.estimation; i++) {
            this.reviewRow
                .find(".review-estimation")
                .append(STAR_OUTLINE);
            this.reviewRowAtUserPage
                .find(".review-estimation")
                .append(STAR_OUTLINE);
        }
    }

    getReviewRow() {
        return this.reviewRow;
    }
}
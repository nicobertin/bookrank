import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="stars"
export default class extends Controller {
  static targets = ["star", "ratingInput"];

  connect() {
    this.updateStars(parseInt(this.ratingInputTarget.value) || 0);
  }

  selectRating(event) {
    const rating = parseInt(event.currentTarget.dataset.value);
    this.ratingInputTarget.value = rating;
    this.updateStars(rating);
  }

  hoverRating(event) {
    const rating = parseInt(event.currentTarget.dataset.value);
    this.updateStars(rating);
  }

  resetRating() {
    this.updateStars(parseInt(this.ratingInputTarget.value) || 0);
  }

  updateStars(rating) {
    this.starTargets.forEach((star, index) => {
      if (index < rating) {
        star.classList.add("active");
      } else {
        star.classList.remove("active");
      }
    });
  }
}

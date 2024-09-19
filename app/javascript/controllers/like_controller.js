import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["likeButton", "likeIcon", "likeText"]

  toggleLike(event) {
    event.preventDefault();
    const isLiked = this.likeButtonTarget.classList.contains("liked");

    if (isLiked) {
      this.likeButtonTarget.classList.remove("liked");
      this.likeIconTarget.classList.remove("hidden");
      this.likeTextTarget.textContent = "Like";
    } else {
      this.likeButtonTarget.classList.add("liked");
      this.likeIconTarget.classList.add("hidden");
      this.likeTextTarget.textContent = "Unlike";
    }
  }
}

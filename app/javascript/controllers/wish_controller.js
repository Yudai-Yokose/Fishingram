import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["element"];
  static values = {
    delay: { type: Number, default: 500 }
  };

  connect() {
    this.showRemainingElements();
  }

  showRemainingElements() {
    this.elementTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.remove("hidden");
        element.classList.add("fade-in-bottom");
      }, this.delayValue * index);
    });
  }

}
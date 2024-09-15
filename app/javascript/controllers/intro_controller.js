import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["element"];
  static values = { delay: Number };

  connect() {
    this.showFirstElement();
  }

  showFirstElement() {
    const firstElement = this.elementTargets[0];
    firstElement.classList.remove("hidden");
    firstElement.classList.add("fade-in-top");

    setTimeout(() => {
      this.showSecondElement();
    }, 500);
  }

  showSecondElement() {
    const secondElement = this.elementTargets[1];
    secondElement.classList.remove("hidden");
    secondElement.classList.add("fade-in-bottom");

    setTimeout(() => {
      this.hideFirstElements();
      this.showRemainingElements();
    }, 2000);
  }

  hideFirstElements() {
    this.elementTargets.slice(0, 2).forEach((element) => {
      element.classList.add("hidden");
    });
  }

  showRemainingElements() {
    this.elementTargets.slice(2).forEach((element, index) => {
      setTimeout(() => {
        element.classList.remove("hidden");

        if (element.tagName === "HR") {
          element.classList.add("show");
        } else {
          element.classList.add("fade-in-bottom");
        }
      }, this.delayValue * index);
    });
  }
}
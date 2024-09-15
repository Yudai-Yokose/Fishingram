import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: { type: Number, default: 3000 } }

  connect() {
    this.startFadeOut();

    document.addEventListener("turbo:frame-load", () => {
      this.startFadeOut();
    });
  }

  startFadeOut() {
    setTimeout(() => {
      this.fadeOut();
    }, this.timeoutValue);
  }

  fadeOut() {
    this.element.classList.add("fade-out");
    setTimeout(() => {
      this.element.style.visibility = "hidden";
    }, 500); 
  }
}
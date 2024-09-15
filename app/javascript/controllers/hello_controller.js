import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"];

  toggle(event) {
    this.contentTarget.classList.toggle("hidden");
  }

  stopToggle(event) {
    event.stopPropagation();
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"];

  resetForm() {
    this.formTarget.reset();
    const suggestions = document.querySelectorAll("[data-autocomplete-target='suggestions']");
    suggestions.forEach((suggestion) => (suggestion.innerHTML = ""));
  }
}

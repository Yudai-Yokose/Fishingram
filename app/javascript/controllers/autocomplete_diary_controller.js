import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions"];

  connect() {
    document.addEventListener("click", this.hideSuggestions.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.hideSuggestions.bind(this));
  }

  async search() {
    const query = this.inputTarget.value;

    if (query.length < 2) {
      this.clearSuggestions();
      return;
    }

    try {
      const response = await fetch(`/diaries/autocomplete?q=${query}`);
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

      const results = await response.json();
      this.updateSuggestions(results);
    } catch (error) {
      console.error("Error fetching autocomplete results:", error);
    }
  }

  updateSuggestions(suggestions) {
    this.clearSuggestions();
    suggestions.forEach((suggestion) => {
      const item = document.createElement("li");
      item.textContent = suggestion;
      item.className = "p-2 cursor-pointer hover:bg-blue-100 dark:hover:bg-gray-600";
      item.addEventListener("click", (event) => this.selectSuggestion(event, suggestion));
      this.suggestionsTarget.appendChild(item);
    });
  }

  selectSuggestion(event, suggestion) {
    event.stopPropagation();
    this.inputTarget.value = suggestion;
    this.clearSuggestions();
  }

  hideSuggestions(event) {
    if (!this.element.contains(event.target)) {
      this.clearSuggestions();
    }
  }

  clearSuggestions() {
    this.suggestionsTarget.innerHTML = "";
  }
}

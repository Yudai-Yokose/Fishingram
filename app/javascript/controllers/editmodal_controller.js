import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="editmodal"
export default class extends Controller {
  static targets = ["editModal"];

  connect() {
    this.element.addEventListener("turbo:submit-end", this.closeModal.bind(this))
  }

  closeModal(event) {
    if (event.detail.success) { 
      const modal = this.editModalTarget;
      if (modal) {
        modal.close();
      }
    }
  }
}

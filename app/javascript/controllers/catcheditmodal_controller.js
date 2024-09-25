import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { catchId: Number }

  connect() {
    this.element.addEventListener("turbo:submit-end", this.closeModal.bind(this))
  }

  closeModal(event) {
    if (event.detail.success) {
      const modalCloseButton = document.querySelector(`[data-modal-hide='catcheditmodal_${this.catchIdValue}']`)
      if (modalCloseButton) {
        modalCloseButton.click()
      }
    }
  }
}
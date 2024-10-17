import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { modalId: String }

  connect() {
    this.element.addEventListener("turbo:submit-end", this.closeModal.bind(this))
  }

  closeModal(event) {
    if (event.detail.success) {
      const modalCloseButton = document.querySelector(`[data-modal-hide='${this.modalIdValue}']`)
      if (modalCloseButton) {
        modalCloseButton.click()
      }
    }
  }
}

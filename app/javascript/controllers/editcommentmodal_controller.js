import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { commentId: String }

  connect() {
    this.element.addEventListener("turbo:submit-end", this.closeModal.bind(this))
  }

  closeModal(event) {
    if (event.detail.success) {
      const modalCloseButton = document.querySelector(
        `[data-modal-hide='${this.commentIdValue}']`
      )
      if (modalCloseButton) {
        modalCloseButton.click()
      }
    }
  }
}
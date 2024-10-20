import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { diaryId: Number }

  connect() {
    this.element.addEventListener("turbo:submit-end", this.closeModal.bind(this))
  }

  closeModal(event) {
    if (event.detail.success) {
      const modalCloseButton = document.querySelector(`[data-modal-hide='diaryeditmodal_${this.diaryIdValue}']`)
      if (modalCloseButton) {
        modalCloseButton.click()
      }
    }
  }
}

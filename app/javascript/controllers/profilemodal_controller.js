import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    profilemodal: String
  }
  
  connect() {
    this.element.addEventListener("turbo:submit-end", this.closeModal.bind(this))
    console.log(this.profilemodalValue);
  }

  closeModal(event) {
    if (event.detail.success) {
      const modalCloseButton = document.querySelector("[data-modal-hide='profilemodal']")
      if (modalCloseButton) {
        modalCloseButton.click()
      }
    }
  }
}
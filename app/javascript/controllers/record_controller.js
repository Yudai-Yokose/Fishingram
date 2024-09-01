import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="record"
export default class extends Controller {
  static targets = ["catchTab", "diaryTab", "catchForm", "diaryForm", "recordModal"]

  connect() {
    this.showCatchForm()
    this.element.addEventListener("turbo:submit-end", this.closeModal.bind(this))
  }

  showCatchForm() {
    this.catchTabTarget.classList.add("active")
    this.diaryTabTarget.classList.remove("active")
    this.catchFormTarget.classList.remove("hidden")
    this.diaryFormTarget.classList.add("hidden")
  }

  showDiaryForm() {
    this.catchTabTarget.classList.remove("active")
    this.diaryTabTarget.classList.add("active")
    this.catchFormTarget.classList.add("hidden")
    this.diaryFormTarget.classList.remove("hidden")
  }

  closeModal(event) {
    if (event.detail.success) { 
      const modal = this.recordModalTarget;
      if (modal) {
        modal.close();
      }
    }
  }
}
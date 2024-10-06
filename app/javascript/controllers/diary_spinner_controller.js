import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["diarySpinner"]

  showSpinner(event) {

    this.diarySpinnerTarget.style.display = "flex";
  }
}
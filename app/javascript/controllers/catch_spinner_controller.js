import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["catchSpinner"]

  showSpinner(event) {

    this.catchSpinnerTarget.style.display = "flex";
  }
}
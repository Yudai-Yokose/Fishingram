import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["datepicker", "hiddenField"];

  connect() {
    const today = new Date().toISOString().split('T')[0];

    if (!this.hiddenFieldTarget.value) {
      this.hiddenFieldTarget.value = today;
      this.datepickerTarget.value = today;
    }

    this.initializeDatepicker();
  }

  initializeDatepicker() {
    const datepickerInput = this.datepickerTarget;

    const datepicker = new Datepicker(datepickerInput, {
      autohide: true,
      format: "yyyy-mm-dd"
    });

    datepickerInput.addEventListener("changeDate", (event) => {
      const selectedDate = event.target.value;
      this.hiddenFieldTarget.value = selectedDate;
    });
  }
}
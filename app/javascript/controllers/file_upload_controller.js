import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileName", "fileInput", "label"];

  displayFileName() {
    const input = this.fileInputTarget;
    const fileNameDisplay = this.fileNameTarget;
    const label = this.labelTarget;

    if (input.files.length > 0) {
      fileNameDisplay.textContent = input.files.length === 1
        ? input.files[0].name
        : `${input.files.length} files selected`;

      label.classList.add("ring-2", "ring-blue-500", "border-blue-500");
    } else {
      fileNameDisplay.textContent = "Tap to upload";

      label.classList.remove("ring-2", "ring-blue-500", "border-blue-500");
    }
  }
}
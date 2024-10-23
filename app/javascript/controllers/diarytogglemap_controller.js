import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["diaryLocationFields"];

  connect() {
    this.toggleMapVisibility();
  }

  diarytoggleMap(event) {
    this.toggleMapVisibility(event.currentTarget);
  }

  toggleMapVisibility(checkbox = null) {
    const diaryId = this.element.dataset.diaryIdValue;

    if (!checkbox) {
      checkbox = this.element.querySelector(`input[type="checkbox"]#location-diary-toggle-${diaryId}`);
    }

    if (!checkbox) {
      console.error(`Checkbox with id="location-diary-toggle-${diaryId}" not found.`);
      return;
    }

    const locationFields = this.diaryLocationFieldsTarget;

    if (checkbox.checked) {
      locationFields.style.display = 'block';
      this.initMap(diaryId);
    } else {
      locationFields.style.display = 'none';
      this.clearMapPosition(diaryId);
    }
  }

  initMap(diaryId) {
    const diarynewmapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector(`[data-controller='diarynewmap'][data-diary-id-value='${diaryId}']`),
      "diarynewmap"
    );

    if (diarynewmapController) {
      diarynewmapController.initializeMap();
    } else {
      console.error(`Could not find diarynewmap controller for diary ID ${diaryId}.`);
    }
  }

  clearMapPosition(diaryId) {
    const diarynewmapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector(`[data-controller='diarynewmap'][data-diary-id-value='${diaryId}']`),
      "diarynewmap"
    );

    if (diarynewmapController) {
      diarynewmapController.clearPosition();
    }
  }
}
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["diaryLocationFields"];

  connect() {
    this.toggleMapVisibility();
  }

  diarytoggleMap(event) {
    this.toggleMapVisibility();
  }

  toggleMapVisibility() {
    const checkbox = document.getElementById('location-diarytoggle');
    const locationFields = this.diaryLocationFieldsTarget;

    if (checkbox.checked) {
      locationFields.style.display = 'block';
      this.initMap();
    } else {
      locationFields.style.display = 'none';
      this.clearMapPosition();
    }
  }

  initMap() {
    const diarynewmapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector("[data-controller='diarynewmap']"), "diarynewmap"
    );

    if (diarynewmapController) {
      diarynewmapController.initializeMap();
    } else {
      console.error('Could not find diarynewmap controller');
    }
  }

  clearMapPosition() {
    const diarynewmapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector("[data-controller='diarynewmap']"), "diarynewmap"
    );

    if (diarynewmapController) {
      diarynewmapController.clearPosition();
    }
  }
}
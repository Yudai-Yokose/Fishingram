import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["catchLocationFields"];

  connect() {
    this.toggleMapVisibility();
  }

  catchtoggleMap(event) {
    this.toggleMapVisibility();
  }

  toggleMapVisibility() {
    const checkbox = document.getElementById('location-catch-toggle');
    const locationFields = this.catchLocationFieldsTarget;

    if (checkbox.checked) {
      locationFields.style.display = 'block';
      this.initMap();
    } else {
      locationFields.style.display = 'none';
      this.clearMapPosition();
    }
  }

  initMap() {
    const catchnewmapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector("[data-controller='catchnewmap']"), "catchnewmap"
    );

    if (catchnewmapController) {
      catchnewmapController.initializeMap();
    } else {
      console.error('Could not find catchnewmap controller');
    }
  }

  clearMapPosition() {
    const catchnewmapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector("[data-controller='catchnewmap']"), "catchnewmap"
    );

    if (catchnewmapController) {
      catchnewmapController.clearPosition();
    }
  }
}
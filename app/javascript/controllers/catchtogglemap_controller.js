import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["catchLocationFields"];

  connect() {
    this.toggleMapVisibility();
  }

  catchtoggleMap(event) {
    this.toggleMapVisibility(event.currentTarget);
  }

  toggleMapVisibility(checkbox = null) {
    const catchId = this.element.dataset.catchIdValue;
  
    if (!checkbox) {
      checkbox = this.element.querySelector(`input[type="checkbox"]#location-catch-toggle-${catchId}`);
    }
  
    if (!checkbox) {
      console.error(`Checkbox with id="location-catch-toggle-${catchId}" not found.`);
      return;
    }
  
    const locationFields = this.catchLocationFieldsTarget;
  
    if (checkbox.checked) {
      locationFields.style.display = 'block';
      this.initMap(catchId);
    } else {
      locationFields.style.display = 'none';
      this.clearMapPosition(catchId);
    }
  }

  initMap(catchId) {
    const mapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector(`[data-controller='catchnewmap'][data-catch-id-value='${catchId}']`),
      "catchnewmap"
    );

    if (mapController) {
      mapController.initializeMap();
    } else {
      console.error('Could not find catchnewmap controller');
    }
  }

  clearMapPosition(catchId) {
    const mapController = this.application.getControllerForElementAndIdentifier(
      document.querySelector(`[data-controller='catchnewmap'][data-catch-id-value='${catchId}']`),
      "catchnewmap"
    );

    if (mapController) {
      mapController.clearPosition();
    }
  }
}
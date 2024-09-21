import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["catchLatitude", "catchLongitude"];

  initializeMap() {
    const apiKey = this.element.dataset.mapApiKeyValue;
    const mapId = this.element.dataset.mapIdValue;
  
    this.showSpinner();

    const savedLatitude = this.hasCatchLatitudeTarget ? parseFloat(this.catchLatitudeTarget.value) : null;
    const savedLongitude = this.hasCatchLongitudeTarget ? parseFloat(this.catchLongitudeTarget.value) : null;

    if (savedLatitude && savedLongitude) {
      this.showMap(mapId, { coords: { latitude: savedLatitude, longitude: savedLongitude } });
    } else {
      if (!window.catchMapInitialized) {
        this.loadGoogleMapsAPI(apiKey)
          .then(() => {
            this.setPosition(mapId);
            window.catchMapInitialized = true;
          })
          .catch(error => {
            this.hideSpinner();
          });
      } else {
        this.setPosition(mapId);
      }
    }
  }

  loadGoogleMapsAPI(apiKey) {
    return new Promise((resolve, reject) => {
      if (typeof google === "undefined" || !google.maps) {
        const script = document.createElement("script");
        script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}`;
        script.async = true;
        script.defer = true;
        script.onload = () => {
          resolve();
        };
        script.onerror = (error) => {
          reject(error);
        };
        document.head.appendChild(script);
      } else {
        resolve();
      }
    });
  }

  setPosition(mapId) {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        this.showMap.bind(this, mapId),
        () => {
          this.hideSpinner();
        }
      );
    } else {
      this.hideSpinner();
    }
  }

  showMap(mapId, position) {
    const latitude = position.coords.latitude;
    const longitude = position.coords.longitude;

    if (this.hasCatchLatitudeTarget) {
      this.catchLatitudeTarget.value = latitude;
    }

    if (this.hasCatchLongitudeTarget) {
      this.catchLongitudeTarget.value = longitude;
    }

    this.initMap(latitude, longitude, mapId);
  }

  initMap(lat, lng, mapId) {
    const mapElement = document.getElementById(`catch-map-${this.element.dataset.catchIdValue}`);

    if (!mapElement) {
      console.error("Map element not found");
      return;
    }

    const map = new google.maps.Map(mapElement, {
      center: { lat, lng },
      zoom: 15,
      mapId: mapId,
      disableDefaultUI: true,
      zoomControl: false,
      mapTypeControl: false,
      streetViewControl: false,
      fullscreenControl: false,
      gestureHandling: 'greedy'
    });

    const marker = new google.maps.Marker({
      position: { lat, lng },
      map: map,
      draggable: true,
    });

    this.hideSpinner();

    google.maps.event.addListener(marker, 'dragend', (event) => {
      const newLat = event.latLng.lat();
      const newLng = event.latLng.lng();

      if (this.hasCatchLatitudeTarget) {
        this.catchLatitudeTarget.value = newLat;
      }

      if (this.hasCatchLongitudeTarget) {
        this.catchLongitudeTarget.value = newLng;
      }
    });
  }

  showSpinner() {
    const spinnerElement = document.getElementById(`map-spinner-catch-${this.element.dataset.catchIdValue}`);
    const mapElement = document.getElementById(`catch-map-${this.element.dataset.catchIdValue}`);

    if (spinnerElement) {
      spinnerElement.style.display = 'flex';
    }

    if (mapElement) {
      mapElement.style.display = 'none';
    }
  }

  hideSpinner() {
    const spinnerElement = document.getElementById(`map-spinner-catch-${this.element.dataset.catchIdValue}`);
    const mapElement = document.getElementById(`catch-map-${this.element.dataset.catchIdValue}`);

    if (spinnerElement) {
      spinnerElement.style.display = 'none';
    }

    if (mapElement) {
      mapElement.style.display = 'block';
    }
  }

  clearPosition() {
    if (this.hasCatchLatitudeTarget) {
      this.catchLatitudeTarget.value = '';
    }
    
    if (this.hasCatchLongitudeTarget) {
      this.catchLongitudeTarget.value = '';
    }
  }
}
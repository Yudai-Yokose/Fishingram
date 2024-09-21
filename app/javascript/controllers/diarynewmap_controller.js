import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["diaryLatitude", "diaryLongitude"];

  initializeMap() {
    const apiKey = this.element.dataset.mapApiKeyValue;
    const mapId = this.element.dataset.mapIdValue;
  
    this.showSpinner();

    const savedLatitude = this.hasDiaryLatitudeTarget ? parseFloat(this.diaryLatitudeTarget.value) : null;
    const savedLongitude = this.hasDiaryLongitudeTarget ? parseFloat(this.diaryLongitudeTarget.value) : null;

    if (savedLatitude && savedLongitude) {
      this.showMap(mapId, { coords: { latitude: savedLatitude, longitude: savedLongitude } });
    } else {
      if (!window.diaryMapInitialized) {
        this.loadGoogleMapsAPI(apiKey)
          .then(() => {
            this.setPosition(mapId);
            window.diaryMapInitialized = true;
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

    if (this.hasDiaryLatitudeTarget) {
      this.diaryLatitudeTarget.value = latitude;
    }

    if (this.hasDiaryLongitudeTarget) {
      this.diaryLongitudeTarget.value = longitude;
    }

    this.initMap(latitude, longitude, mapId);
  }

  initMap(lat, lng, mapId) {
    const mapElement = document.getElementById(`diary-map-${this.element.dataset.diaryIdValue}`);

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

      if (this.hasDiaryLatitudeTarget) {
        this.diaryLatitudeTarget.value = newLat;
      }

      if (this.hasDiaryLongitudeTarget) {
        this.diaryLongitudeTarget.value = newLng;
      }
    });
  }

  showSpinner() {
    const spinnerElement = document.getElementById(`map-spinner-diary-${this.element.dataset.diaryIdValue}`);
    const mapElement = document.getElementById(`diary-map-${this.element.dataset.diaryIdValue}`);

    if (spinnerElement) {
      spinnerElement.style.display = 'flex';
    }

    if (mapElement) {
      mapElement.style.display = 'none';
    }
  }

  hideSpinner() {
    const spinnerElement = document.getElementById(`map-spinner-diary-${this.element.dataset.diaryIdValue}`);
    const mapElement = document.getElementById(`diary-map-${this.element.dataset.diaryIdValue}`);

    if (spinnerElement) {
      spinnerElement.style.display = 'none';
    }

    if (mapElement) {
      mapElement.style.display = 'block';
    }
  }

  clearPosition() {
    if (this.hasDiaryLatitudeTarget) {
      this.diaryLatitudeTarget.value = '';
    }

    if (this.hasDiaryLongitudeTarget) {
      this.diaryLongitudeTarget.value = '';
    }
  }
}
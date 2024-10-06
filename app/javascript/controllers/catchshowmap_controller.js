import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { latitude: Number, longitude: Number, mapId: String, apiKey: String, catchId: String };

  connect() {
    const latitude = this.latitudeValue;
    const longitude = this.longitudeValue;
    const mapId = this.mapIdValue;
    const apiKey = this.apiKeyValue;
    const catchId = this.catchIdValue;

    if (!window.google || !window.google.maps) {
      this.loadGoogleMapsAPI(apiKey)
        .then(() => {
          this.initMap(latitude, longitude, mapId, catchId);
        })
        .catch(() => {
          this.showErrorMessage();
        });
    } else {
      try {
        this.initMap(latitude, longitude, mapId, catchId);
      } catch {
        this.showErrorMessage();
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
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
      } else {
        resolve();
      }
    });
  }

  initMap(lat, lng, mapId, catchId) {
    const mapElement = document.getElementById(`map_${catchId}`);

    if (!mapElement) {
      this.showErrorMessage();
      throw new Error("Map element not found");
    }

    const map = new google.maps.Map(mapElement, {
      center: { lat: parseFloat(lat), lng: parseFloat(lng) },
      zoom: 15,
      mapId: mapId,
      disableDefaultUI: true,
      zoomControl: false,
      gestureHandling: 'greedy'
    });

    new google.maps.Marker({
      position: { lat: parseFloat(lat), lng: parseFloat(lng) },
      map: map,
    });
  }

  showErrorMessage() {
    alert("地図を表示できませんでした。ブラウザの設定を確認してください。");
  }
}
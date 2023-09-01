import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    departureCity1Lat: Number,
    departureCity1Lon: Number,
    departureCity2Lat: Number,
    departureCity2Lon: Number,
  }

  connect() {
    console.log("This is connected")
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/dark-v11"
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    // this.markersValue.forEach((marker) => {
    //   console.log(marker)
    //   new mapboxgl.Marker({opacity: 0})
    //   .setLngLat([ marker.lng, marker.lat ])
    //   .addTo(this.map)
    // })
    new mapboxgl.Marker({color: "#705eb6"})
    .setLngLat([this.departureCity1LonValue, this.departureCity1LatValue] )
    .addTo(this.map)

    new mapboxgl.Marker({color: "#705eb6"})
    .setLngLat([this.departureCity2LonValue, this.departureCity2LatValue] )
    .addTo(this.map)
    // Add markers departure cities
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    console.log(this.markersValue)
    this.markersValue.forEach(marker => bounds.extend([
      marker.lng, marker.lat ]))
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0})
  }
}

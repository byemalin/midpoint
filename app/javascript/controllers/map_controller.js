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

  static targets = [
    "mapContainer"
  ]

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.mapContainerTarget,
      style: "mapbox://styles/mapbox/dark-v11",
      center: [(this.departureCity1LatValue + this.departureCity1LonValue)/2,(this.departureCity2LatValue + this.departureCity2LonValue) / 2]
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.map.on('load', () => {
      this.#renderJourneyPath()
    })

    this.animationLoops = {}
  }

  #renderJourneyPath(midpoint) {
    let coordinates = [[this.departureCity1LonValue, this.departureCity1LatValue],[this.departureCity2LonValue, this.departureCity2LatValue]]
    if (midpoint) {
      this.#renderLine("line1", [this.departureCity1LonValue, this.departureCity1LatValue], [midpoint.lng, midpoint.lat] )
      this.#renderLine("line2", [this.departureCity2LonValue, this.departureCity2LatValue], [midpoint.lng, midpoint.lat] )

    } else {
      this.#renderLine("line", [this.departureCity1LonValue, this.departureCity1LatValue], [this.departureCity2LonValue, this.departureCity2LatValue] )
    }
  }

  #renderLine(lineName, startPoint, endPoint) {
    let coordinates = [startPoint,endPoint]
    const geojson = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': {},
          'geometry': {
            'coordinates': coordinates,
            'type': 'LineString'
          }
        }
      ]
    }

    this.map.addSource(lineName, {
      type: 'geojson',
      data: geojson
    })

    this.map.addLayer({
      type: 'line',
      source: lineName,
      id: `${lineName}-background`,
      paint: {
        'line-color': 'purple',
        'line-width': 6,
            'line-opacity': 0.4
          }
        })


    this.map.addLayer({
      type: 'line',
      source: lineName,
      id: `${lineName}-dashed`,
      paint: {
        'line-color': 'purple',
        'line-width': 6,
        'line-dasharray': [0, 4, 3]
      }
    });


    const dashArraySequence = [
      [0, 4, 3],
      [0.5, 4, 2.5],
      [1, 4, 2],
      [1.5, 4, 1.5],
      [2, 4, 1],
      [2.5, 4, 0.5],
      [3, 4, 0],
      [0, 0.5, 3, 3.5],
      [0, 1, 3, 3],
      [0, 1.5, 3, 2.5],
      [0, 2, 3, 2],
      [0, 2.5, 3, 1.5],
      [0, 3, 3, 1],
      [0, 3.5, 3, 0.5]

    ];

    let step = 0;
    const animateDashArray = (map, timestamp, dashArraySequence, lineName) =>  {
  // Update line-dasharray using the next value in dashArraySequence. The
  // divisor in the expression `timestamp / 50` controls the animation speed.

      const newStep = parseInt(
        (timestamp / 50) % dashArraySequence.length
      );

      if (newStep !== step) {
        map.setPaintProperty(
        `${lineName}-dashed`,
        'line-dasharray',
        dashArraySequence[step]
        );
        step = newStep;
      }
    // Request the next frame of the animation.

      this.animationLoops[lineName] = requestAnimationFrame((timestamp) => {animateDashArray(map, timestamp, dashArraySequence, lineName)});
    }

// start the animation
    animateDashArray(this.map, 0, dashArraySequence, lineName);

  }

  #addMarkersToMap() {

    this.markers = {}
    this.markersValue.forEach((marker) => {
      const mapMarker = new mapboxgl.Marker()
      .setLngLat([ marker.lng, marker.lat ])
      .addTo(this.map)
      this.markers[marker.id] = mapMarker
      const selectedCard = document.querySelector(`[data-midpoint-dest-id-value="${marker.id}"]`)
      mapMarker.getElement().addEventListener("click", () => {
        this.#changeCardFocus(selectedCard)
      })
    })
    new mapboxgl.Marker({color: "#705eb6"})
    .setLngLat([this.departureCity1LonValue, this.departureCity1LatValue] )
    .addTo(this.map)

    new mapboxgl.Marker({color: "#705eb6"})
    .setLngLat([this.departureCity2LonValue, this.departureCity2LatValue] )
    .addTo(this.map)
  }

  #changeCardFocus(selectedCard) {
    const allDestinationCards = document.querySelectorAll(".destination-card-midpoint")
    const filteredCards = [...allDestinationCards]
    filteredCards.forEach((card) => card.style.border = "1px solid #909090")
    selectedCard.style.border = "4px solid #705eb6"
    const destinationId = parseInt(selectedCard.dataset.midpointDestIdValue)
    this.#changeDestination(destinationId)
    this.#fitMapToMarkers(destinationId)
    selectedCard.scrollIntoView()
  }

  #fitMapToMarkers(destinationId) {
    const destination = this.markersValue.find(element => element.id === destinationId)
    const bounds = new mapboxgl.LngLatBounds()
    bounds.extend([this.departureCity1LonValue, this.departureCity1LatValue])
    if (destination){
      console.log(destination)
      bounds.extend([destination.lng, destination.lat])
    }
    bounds.extend([this.departureCity2LonValue, this.departureCity2LatValue])
    this.map.fitBounds(bounds, { padding: 50, maxZoom:4, duration: 0})
  }

  renderChange({detail: {destinationId}}) {
    this.#changeDestination(destinationId)
    this.#fitMapToMarkers(destinationId)
  }

  #changeDestination(destinationId) {
    this.#removeMapLines()
    const destination = this.markersValue.find(element => element.id === destinationId)
    const selectedMarker = this.markers[destinationId]
    for (const [_id, marker] of Object.entries(this.markers)) {
      this.#setMarkerColor(marker, "rgb(63, 177, 206)")
    }
    this.#setMarkerColor(selectedMarker, "#705eb6")
    this.#renderJourneyPath(destination)
  }

  #removeMapLines() {
    if (this.map.getSource("line")) {
      this.map.removeLayer("line-dashed")
      this.map.removeLayer("line-background")
      this.map.removeSource("line")
      cancelAnimationFrame(this.animationLoops["line"])
    }
    if (this.map.getSource("line1")) {
      this.map.removeLayer("line1-dashed")
      this.map.removeLayer("line1-background")
      this.map.removeSource("line1")
      cancelAnimationFrame(this.animationLoops["line1"])
    }
    if (this.map.getSource("line2")) {
      this.map.removeLayer("line2-dashed")
      this.map.removeLayer("line2-background")
      this.map.removeSource("line2")
      cancelAnimationFrame(this.animationLoops["line2"])
    }
  }

  #setMarkerColor(marker, color) {
    let markerElement = marker.getElement();
    markerElement
      .querySelectorAll('svg path[fill="' + marker._color + '"]')[0]
      .setAttribute("fill", color);
    marker._color = color;
  }
}

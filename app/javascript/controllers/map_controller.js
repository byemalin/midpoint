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
  }

  #renderJourneyPath(midpoint) {
    let coordinates = [[this.departureCity1LonValue, this.departureCity1LatValue],[this.departureCity2LonValue, this.departureCity2LatValue]]
    if (midpoint){
      coordinates.splice(1, 0, [midpoint.lng, midpoint.lat])
    }
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

      this.map.addSource('line', {
        type: 'geojson',
        data: geojson
      })

      this.map.addLayer({
        type: 'line',
        source: 'line',
        id: 'line-background',
        paint: {
          'line-color': 'purple',
          'line-width': 6,
          'line-opacity': 0.4
        }
      })


      this.map.addLayer({
        type: 'line',
        source: 'line',
        id: 'line-dashed',
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
      function animateDashArray(map, timestamp, dashArraySequence) {
    // Update line-dasharray using the next value in dashArraySequence. The
    // divisor in the expression `timestamp / 50` controls the animation speed.
        const newStep = parseInt(
          (timestamp / 50) % dashArraySequence.length
        );

        if (newStep !== step) {
          map.setPaintProperty(
          'line-dashed',
          'line-dasharray',
          dashArraySequence[step]
          );
          step = newStep;
        }

      // Request the next frame of the animation.
        requestAnimationFrame(()=> {animateDashArray(map, 0, dashArraySequence)});
      }

// start the animation
      animateDashArray(this.map, 0, dashArraySequence);
  }

  getCoords(event) {
    console.log(event.currentTarget)
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      new mapboxgl.Marker()
      .setLngLat([ marker.lng, marker.lat ])
      .addTo(this.map)
    })
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
    bounds.extend([this.departureCity1LonValue, this.departureCity1LatValue-6])
    bounds.extend([this.departureCity2LonValue, this.departureCity2LatValue+6])
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0})
  }

  log({detail: {destinationId}}) {
    // remove layer
    this.map.removeLayer("line-background")
    this.map.removeLayer("line-dashed")
    this.map.removeSource("line")
    const destination = this.markersValue.find(element => element.id === destinationId)
    this.#renderJourneyPath(destination)
  }

}

// Remove layer, pass lat and long back through render Journey path

import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {

  static targets = [
    "departureDate",
  ]

  connect() {
      flatpickr(this.departureDateTarget, {
        "dateFormat": "d-m-Y",
      })
      // Add option config
  }
}

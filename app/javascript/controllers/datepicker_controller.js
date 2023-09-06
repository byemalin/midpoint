import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {

  static targets = [
    "departureDate",
  ]

  connect() {
      flatpickr(this.departureDateTarget, {
        "dateFormat": "d-m-Y",
        "disable": [
          {
              from: "01-04-2021",
              to: "07-09-2023"
          }
      ]
      })
      // Add option config
  }
}

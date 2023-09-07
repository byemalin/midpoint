import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
const date = new Date()

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
              to: `${date.getDate()-1}-${date.getMonth()}-${date.getFullYear()}`
          }
        ]
      })
  }
}

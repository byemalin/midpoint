import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [
    "destination"
  ]

  static values = {
    destId: Number
  }

  connect() {
  }

  setMidpoint() {
    this.dispatch("cardHover", { detail: { destinationId: this.destIdValue } })
  }
}

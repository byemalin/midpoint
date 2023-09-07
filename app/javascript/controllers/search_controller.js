import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {

  static targets = ["submitButton", "loading", "search"]

  loading() {
    console.log("Hi there")
    this.searchTarget.classList.add("d-none")
    this.loadingTarget.classList.remove("d-none")
  }

}

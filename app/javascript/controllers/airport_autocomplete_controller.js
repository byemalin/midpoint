import { Controller } from "@hotwired/stimulus";
import autoComplete from "@tarekraafat/autocomplete.js";


// Connects to data-controller="airport-autocomplete"
export default class extends Controller {

  static targets = [
    "inputField",
  ]

  connect() {
    console.log("Airport autocomplete controller connected")

    const autoCompleteJS = new autoComplete({
      placeHolder: "First City",
        data: {
            src: async () => {
              try {
                const source = await fetch(
                  `/tequila_airports?term=${this.inputFieldTarget.value}`,
                  {
                    verb: "GET",
                    headers: {
                      accept: "application/json",
                    }
                  }
                );
                const data = await source.json();

                const resultsArray = data.locations.map((location) => {
                  return `${location.name} ${location.city.name} ${location.id}`
                })

                return resultsArray

              } catch (error) {
                return error;
              }
            },
        },
        resultItem: {
            highlight: true,
        },
        selector: ".autocomplete"
     });
  }

  complete(event){
    console.log("Completing...")

    const feedback = event.detail;
    const selection = feedback.selection.value;

    this.inputFieldTarget.value = selection.split(" ").pop();
  }
}

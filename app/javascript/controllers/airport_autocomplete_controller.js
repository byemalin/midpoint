import { Controller } from "@hotwired/stimulus";
import autoComplete from "@tarekraafat/autocomplete.js";


// Connects to data-controller="airport-autocomplete"
export default class extends Controller {

  static targets = [
    "inputField"
  ]

  connect() {
    console.log("Airport autocomplete controller connected")
    console.log(this.element)

    const autoCompleteJS = new autoComplete({
        data: {
            src: async () => {
              try {
                console.log(this.inputFieldTarget)
                if (this.inputFieldTarget.value){
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
                    return `${location.city.name} - ${location.id}`
                  })

                  return resultsArray
                }
                return []

              } catch (error) {
                return error;
              }
            },
        },
        resultItem: {
            highlight: true,
        },
        // selector: `.autocomplete`
        selector: `#${this.element.id} .autocomplete`
     });
  }

  complete(event){
    console.log("Completing...")

    const feedback = event.detail;
    const selection = feedback.selection.value;

    this.inputFieldTarget.value = selection;
  }
}

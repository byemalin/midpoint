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
            // src: ["Paris", "Potato", "London"]
            src: async () => {
              try {
                const source = await fetch(
                  `https://api.tequila.kiwi.com/locations/query?term=${this.inputFieldTarget.value}&locale=en-US&location_types=airport&limit=10&active_only=true`,
                  {
                    verb: "GET",
                    headers: {
                      accept: "application/json",
                      apiKey: "KTH3IygbkkyMYtEBPQ6n7xpCK5mMwv3R"
                    }
                  }
                );
                const data = await source.json();

                console.log(data.locations)

                const newArray = data.locations.map((location) => {
                  return `${location.name} ${location.city.name} ${location.id}`
                })

                // console.log(newArray)
                return newArray

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

class FindSuggestionsJob < ApplicationJob
  queue_as :default

  def perform(airport)
    airport.update(suggestions: suggestions_from_openai(airport.city_name, airport.country_name))
  end

  private
  def suggestions_from_openai(city_name, country_name)
    prompt = "Give top 5 places to see in #{city_name}, #{country_name}"
    client = OpenAI::Client.new
    # OpenAI.rough_token_count("Your text") #Counting tokens to estimate your costs.
    response = client.chat(
    parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: prompt}], # Required.
        temperature: 0.7,
    })

    openai_response = response.dig("choices", 0, "message", "content")
    openai_response
  end
end

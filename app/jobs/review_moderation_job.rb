require 'net/http'
require 'uri'
require 'json'

class ReviewModerationJob < ApplicationJob
  queue_as :default

  OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions'

  def perform(review_id)
    review = Review.find_by(id: review_id)
    return unless review

    user = review.user
    content = review.content

    prompt = build_moderation_prompt(content)
    result = call_openai_api(prompt)

    if result[:inappropriate]
      user.update(banned: true)
      Rails.logger.info "User #{user.id} has been banned due to inappropriate content."
    else
      Rails.logger.info "Review #{review.id} passed moderation."
    end
  end

  private

  def build_moderation_prompt(content)
    <<~PROMPT
      Analyze the following review comment and determine if it contains inappropriate language, hate speech, threats, or offensive content:

      "#{content}"

      Respond with a JSON object in the following format:
      {
        "inappropriate": true or false
      }
    PROMPT
  end

  def call_openai_api(prompt)
    api_key = Rails.application.credentials.open_ai[:api_key]

    body = {
      model: "gpt-4o-mini",
      messages: [
        { role: "system", content: "You are a content moderation assistant." },
        { role: "user", content: prompt }
      ]
    }

    uri = URI.parse(OPENAI_API_URL)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{api_key}"
    request.body = body.to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    parse_response(response)
  rescue StandardError => e
    Rails.logger.error "Error calling OpenAI API: #{e.message}"
    { inappropriate: false }
  end

  def parse_response(response)
    if response.is_a?(Net::HTTPSuccess)
      content = JSON.parse(response.body).dig('choices', 0, 'message', 'content')
      
      cleaned_content = content.gsub(/```json/, '').gsub(/```/, '').strip

      JSON.parse(cleaned_content, symbolize_names: true)
    else
      Rails.logger.error "OpenAI API Error: #{response.code} - #{response.body}"
      { inappropriate: false }
    end
  rescue JSON::ParserError => e
    Rails.logger.error "JSON Parsing Error: #{e.message}"
    { inappropriate: false }
  end
end
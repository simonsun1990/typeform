class TypeformController < ApplicationController
  def index
    json= {
      "title": "My first typeform",
      "fields": [
        {
          "type": "short_text",
          "question": "What is your first name?"
        },
        {
          "type": "short_text",
          "question": "What is your last name?"
        },
        {
          "type": "short_text",
          "question": "What is your telephone number?"
        },
        {
          "type": "short_text",
          "question": "What is your email address?"
        }
      ]
    }
    c = Curl::Easy.http_post("https://api.typeform.io/latest/forms",json.to_json) do |curl|
      curl.headers["X-API-TOKEN"] = "1cef87c8fd76d4afa3cb5420f2f95b23"
    end
    c.perform
    response= JSON.parse(c.body)
    typeform_url = response['_links'][1]['href']
    redirect_to typeform_url
  end



end
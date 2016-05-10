class TypeformController < ApplicationController
  skip_before_action :verify_authenticity_token
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
      ],
      "webhook_submit_url": "https://typeform-simon.herokuapp.com/typeform/notify"
    }
    c = Curl::Easy.http_post("https://api.typeform.io/latest/forms",json.to_json) do |curl|
      curl.headers["X-API-TOKEN"] = "1cef87c8fd76d4afa3cb5420f2f95b23"
    end
    c.perform
    response= JSON.parse(c.body)
    typeform_url = response['_links'][1]['href']
    redirect_to typeform_url
  end


  def notify
    p '======= Notify Start ========'
    p params
    p '======= Notify End ========='
    # fetch answers
    if params['answers'].present?
      first_name = params['answers'][0]['value']
      last_name = params['answers'][1]['value']
      telephone_no = params['answers'][2]['value']
      email=params['answers'][3]['value']
    end
    # I tried campaign id of talkpush and found id 100 is useful.
    campaign_id =100
    talkpush_api_params = "api_key=48530ba23eef6b45ffbc95d7c20a60b9&api_secret=e2f724ba060f82ddf58923af494578a7&campaign_invitation[first_name]=#{first_name}&campaign_invitation[last_name]=#{last_name}&campaign_invitation[user_phone_number]=#{telephone_no}&campaign_invitation[email]=#{email}&source=Simon"
    c = Curl::Easy.http_post("http://my.talkpush.com/api/talkpush_services/campaigns/#{campaign_id}/campaign_invitations?"+talkpush_api_params) do |curl|
    end
    c.perform
  end
end

class StackUser < ApplicationRecord
  belongs_to :user

  def update_details
    api_key = AppConfig['se_api_key']
    filter = '!bWUXTP2WcWld0F'
    api_resp = HTTParty.get("https://api.stackexchange.com/2.2/me?key=#{api_key}&access_token=#{access_token}&site=stackoverflow&filter=#{filter}")
    if api_resp.code == 200
      user_json = JSON.parse api_resp.body
      self.network_id = user_json['items'][0]['account_id']
      self.username = user_json['items'][0]['display_name']

      # Haaaaaaaaack.
      self.chat_so_id = Net::HTTP.get_response(URI.parse("https://chat.stackoverflow.com/accounts/#{network_id}"))['location'].scan(%r{/\d+/})[0]
      self.chat_se_id = Net::HTTP.get_response(URI.parse("https://chat.stackexchange.com/accounts/#{network_id}"))['location'].scan(%r{/\d+/})[0]

      save
    else
      logger.error "/me request returned status #{api_resp.code}: #{api_resp.body}"
      false
    end
  end
end

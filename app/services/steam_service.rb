require 'typhoeus'

class SteamService
  WEB_API_BASE_URL = 'https://api.steampowered.com'.freeze
  STOREFRONT_API_BASE_URL = 'https://store.steampowered.com/api'.freeze

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_player_numbers(appid)
    endpoint = "/ISteamUserStats/GetNumberOfCurrentPlayers/v1/"
    params = { appid: appid }
    response = perform_request(endpoint, params, WEB_API_BASE_URL)
    response["response"]["player_count"]
  end

  def fetch_game_data(appid)
    endpoint = "/appdetails"
    params = { appids: appid }
    response = perform_request(endpoint, params, STOREFRONT_API_BASE_URL)
    
    response_unwrap = response["#{appid}"]["data"]
    game_name = response_unwrap["name"]
    game_description = response_unwrap["short_description"]
    game_image = response_unwrap["header_image"]
    game_developers = response_unwrap["developers"][0]
    
    response_data = {
      "name" => game_name,
      "description" => game_description,
      "image" => game_image,
      "developer" => game_developers
    }

  end

  def perform_request(endpoint, params, base_url)
    full_url = "#{base_url}#{endpoint}"
    
    response = Typhoeus.get(full_url, params: params.merge(format: 'json'))
    
    if response.success?
      JSON.parse(response.body)
    else
      error_message = begin
                        JSON.parse(response.body)["error"]["message"]
                      rescue StandardError
                        "Invalid ID or other error."
                      end
      raise "Error fetching data from Steam: #{error_message}"
    end
  end
end
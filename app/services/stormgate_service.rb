require 'typhoeus'

class StormgateService
  BASE_URL = 'https://api.stormgateworld.com/v0'.freeze
  PLAYER_IDS = ["oY6Jjp", "S3g5b0", "9qgUTN", "GSHdDE", "M3GHer", "t7X90h", "9kUUT1", "mmXmQA", "VQgqR6", "gOIX3u"]

  def fetch_leaderboards
    endpoint = "/leaderboards/ranked_1v1"
    response = perform_request(endpoint)
    response["entries"]
  end

  def fetch_player(player_id)
    endpoint = "/players/#{player_id}"
    response = perform_request(endpoint)
  end

  def fetch_player_matches(player_id)
  endpoint = "/players/#{player_id}/matches"
  response = perform_request(endpoint)
  # I think we can nest a bit further
  response["matches"]
  end

  def perform_request(endpoint, params: nil)
    full_url = "#{BASE_URL}#{endpoint}"
    
    options = params ? {params: params.merge(format: 'json')} : {}
    
    response = Typhoeus.get(full_url, options)

    if response.success?
      JSON.parse(response.body)
    else
      error_message = begin
                        JSON.parse(response.body)["error"]["message"]
                      rescue StandardError
                        "Invalid ID or other error"
                      end
      raise "Error fetching data from Stormgate API: #{error_message}"
    end
  end
end

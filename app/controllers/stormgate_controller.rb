require_relative 'base_controller'
require_relative '../services/stormgate_service'

class StormgateController < BaseController
  def initialize
    @stormgate_service = StormgateService.new()
  end
  def call(env)
    req = Rack::Request.new(env)

    case req.path_info
    when "/leaderboards"
      get_leaderboards
    when "/player"
      get_player(req)
    when "/player/matches"
      get_player_matches(req)
    else
      response({"error" => "Not Found"}, status: 404)
    end
    rescue => e
      response({"error" => e.message}, status: 500)
  end
  
  def get_leaderboards
    leaderboards = @stormgate_service.fetch_leaderboards
    response(leaderboards)
  end

  def get_player(req)
    if req.params['id']
      player_id = req.params['id']
      player = @stormgate_service.fetch_player(player_id)
      response(player)
    else
      response({"error" => "Missing player ID"}, status: 400)
    end
  end

  def get_player_matches(req)
    if req.params['id']
      player_id = req.params['id']
      matches = @stormgate_service.fetch_player_matches(player_id)
      response(matches)
    else
      response({"error" => "Missing player ID"}, status: 400)
    end
  end
end
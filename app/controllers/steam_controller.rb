require_relative 'base_controller'
require_relative '../services/steam_service'
require_relative '../services/database_service'

class SteamController < BaseController
  def initialize
    @steam_service = SteamService.new(ENV['STEAM_API_KEY'])
    @db_service = DatabaseService.instance
  end

  def call(env)
    req = Rack::Request.new(env)
  
    case req.path_info
    when "/game"
      game_data(req)
    when "/players"
      player_numbers(req)
    else
      response({"error" => "Not Found"}, status: 404)
    end
    rescue => e
      response({"error" => e.message}, status: 500)
  end
  
  private
  
  def game_data(req)
    if req.params['id']
      appid = req.params['id'].to_i
      game_data = @db_service.find_game(appid)
      
      puts "Game data from DB: #{game_data.inspect}"
      
      if game_data.nil?
        puts "Fetching from Steam service"
        game_data = @steam_service.fetch_game_data(appid)
        @db_service.save_game(appid, game_data) unless game_data.nil?
      end
  
      if game_data
        response(game_data)
      else
        response({"error" => "Game data not found for appid #{appid}"}, status: 404)
      end
    else
      response({"error" => "Missing game ID"}, status: 400) # Bad Request
    end
  end
  
  def player_numbers(req)
    if req.params['id']
      appid = req.params['id']
      player_numbers = @steam_service.fetch_player_numbers(appid)
      response({"player_count" => player_numbers})
    else
      response({"error" => "Missing game ID"}, status: 400) # Bad Request
    end
  end
end


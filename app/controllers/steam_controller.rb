require_relative 'base_controller'
require_relative '../services/steam_service'
require_relative '../services/database_service'
require_relative '../models/game'

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
      game = Game.find(appid)
      
      if game.nil?
        puts "Fetching from Steam service"
        game_data = @steam_service.fetch_game_data(appid)
        unless game_data.nil?
          game = Game.new(appid: appid, name: game_data['name'], description: game_data['description'], image: game_data['image'], developer: game_data['developer'])
          game.save
        end
      end
  
      if game
        response({
          'name' => game.name,
          'description' => game.description,
          'image' => game.image,
          'developer' => game.developer
        })
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


require 'spec_helper'
require_relative '../../app/controllers/steam_controller'

RSpec.describe SteamController do
  include Rack::Test::Methods

  let(:app) { SteamController.new }

  before do
    # Stubbing SteamService methods used by SteamController
    allow_any_instance_of(SteamService).to receive(:fetch_game_data).with("123").and_return({"gameData" => "Some data"})
    allow_any_instance_of(SteamService).to receive(:fetch_player_numbers).with("123").and_return(1000)
  end

  describe 'GET /game' do
    it 'returns game data when id is provided' do
      get '/game', id: '123'
      expect(last_response).to be_ok
      expect(last_response.body).to eq({"gameData" => "Some data"}.to_json)
    end

    it 'returns error when id is missing' do
      get '/game'
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({"error" => "Missing game ID"}.to_json)
    end
  end

  describe 'GET /players' do
    it 'returns player count when id is provided' do
      get '/players', id: '123'
      expect(last_response).to be_ok
      expect(last_response.body).to eq({"player_count" => 1000}.to_json)
    end

    it 'returns error when id is missing' do
      get '/players'
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq({"error" => "Missing game ID"}.to_json)
    end
  end
end

require 'spec_helper'
require_relative '../../app/controllers/mana_trends_controller'
require 'json'

RSpec.describe ManaTrendsController do
  include Rack::Test::Methods

  let(:app) { ManaTrendsController.new }

  describe 'GET /' do
    it 'returns welcome message' do
      get '/'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq("Welcome to ManaTrends!")
    end
  end

  describe 'GET /about' do
    it 'returns about message' do
      get '/about'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq("ManaTrends is a service for tracking the popularity of games on Steam.")
    end
  end

  describe 'GET /nonexistent' do
    it 'returns Not Found for unknown routes' do
      get '/nonexistent'
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)).to eq({"error" => "Not Found"})
    end
  end
end

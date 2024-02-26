require 'spec_helper'
require_relative '../../app/services/steam_service'

RSpec.describe SteamService do
  describe "#fetch_game_data" do
    let(:api_key) { "key" }
    let(:appid) { "361420" }
    let(:service) { SteamService.new(api_key) }

    before do
      stub_request(:get, "https://store.steampowered.com/api/appdetails")
        .with(query: {appids: appid, format: 'json'})
        .to_return(status: 200, body: {appid => {data: {gameName: "Astroneer"}}}.to_json)
    end

    it "retrieves game data from the steam API" do
      data = service.fetch_game_data(appid)
      expect(data).to have_key(appid)
      expect(data[appid]).to have_key("data")
      expect(data[appid]["data"]).to have_key("gameName")
      expect(data[appid]["data"]["gameName"]).to eq("Astroneer")
    end
  end
end

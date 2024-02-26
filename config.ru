require 'dotenv/load'
require_relative 'config/scylla_connection'
require_relative 'app/controllers/steam_controller'
require_relative 'app/controllers/mana_trends_controller'
require_relative 'app/controllers/stormgate_controller'

app = Rack::Builder.new do
  map '/' do
    run ManaTrendsController.new
  end
  
  map '/steam' do
    run SteamController.new
  end

  map '/stormgate' do
    run StormgateController.new
  end
end

#TEMP
class SimpleLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  end
end

use SimpleLogger

run app
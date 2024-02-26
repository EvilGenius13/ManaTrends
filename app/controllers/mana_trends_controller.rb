require_relative 'base_controller'

class ManaTrendsController < BaseController
  def call(env)
    req = Rack::Request.new(env)
    
    case req.path_info
    when "/"
      response("Welcome to ManaTrends!")
    when "/about"
      response("ManaTrends is a service for tracking the popularity of games on Steam.")
    else
      response({"error" => "Not Found"}, status: 404)
    end
  end
end
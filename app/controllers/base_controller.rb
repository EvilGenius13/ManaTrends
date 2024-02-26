require 'json'

class BaseController
  def response(body, status: 200, headers: {})
    headers['Content-Type'] = 'application/json' unless headers.key?('Content-Type')
    headers['X-Environment'] = ENV['RACK_ENV'] || 'dev'
    
    [status, headers, [body.to_json]]
  end
end

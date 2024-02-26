require 'cassandra'
require 'singleton'

class DatabaseService
  include Singleton

  def initialize
    @cluster = Cassandra.cluster(
      hosts: ['127.0.0.1'],
      port: 9042,
      connections_per_local_node: 3,
      connections_per_remote_node: 2,
      max_requests_per_connection: 1024
    )
    @session = @cluster.connect('manatrends_keyspace')
  end

  def find_game(appid)
    appid_int = appid.to_i

    prepared = @session.prepare("SELECT * FROM steam_game WHERE app_id = ?")
    result = @session.execute(prepared, arguments: [appid_int]).first
    result
  rescue => e
    puts "Error executing query: #{e.message}"
    nil
  end
  
  def save_game(appid, data)
    puts "Saving game data: appid=#{appid.inspect}, data=#{data.inspect}"
  
    appid_int = appid.to_i
    name = data['name']
    description = data['description']
    image = data['image']
    developer = data['developer']

    #TODO: check on pulling from DB now as there is an issue
    prepared = @session.prepare("INSERT INTO steam_game (app_id, name, description, image, developer) VALUES (?, ?, ?, ?, ?)")
    @session.execute(prepared, arguments: [appid_int, name, description, image, developer])

    rescue => e
      puts "Error executing query: #{e.message}"
  end
end
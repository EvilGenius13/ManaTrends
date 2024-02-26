require 'typhoeus'
require 'json'
require 'benchmark'

game_ids = [
  '440',    # Team Fortress 2
  '570',    # Dota 2
  '730',    # Counter-Strike: Global Offensive
  '620',    # Portal 2
  '105600', # Terraria
  '252950', # Rocket League
  '291550', # Brawlhalla
  '377160', # Fallout 4
  '230410', # Warframe
  '218620', # PAYDAY 2
]

# Function to make individual requests
def individual_requests(game_ids)
  game_ids.each do |id|
    response = Typhoeus.get("https://store.steampowered.com/api/appdetails?appids=#{id}")
    puts "Game ID: #{id}, Status: #{response.code}"
  end
end

# Function to make concurrent requests using Hydra
def concurrent_requests(game_ids)
  hydra = Typhoeus::Hydra.hydra
  requests = game_ids.map do |id|
    request = Typhoeus::Request.new("https://store.steampowered.com/api/appdetails?appids=#{id}")
    hydra.queue(request)
    request
  end
  hydra.run
  requests.each do |request|
    puts "Game ID: #{request.url.split('=').last}, Status: #{request.response.code}"
  end
end

puts "Benchmarking individual requests:"
time_individual = Benchmark.measure do
  individual_requests(game_ids)
end
puts time_individual

puts "\nBenchmarking concurrent requests with Hydra:"
time_concurrent = Benchmark.measure do
  concurrent_requests(game_ids)
end
puts time_concurrent

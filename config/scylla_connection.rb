require 'dotenv/load'
require 'cassandra'

Dotenv.load

if ENV['RACK_ENV'] = 'development'
  cluster = Cassandra.cluster(
  hosts: ['127.0.0.1'],
  port: 9042
  )
else
  cluster = Cassandra.cluster(
  hosts: ['scylla'],
  port: 9042
  )
end

# Function to create keyspace if it doesn't exist
def create_keyspace(session)
  session.execute(
    """
    CREATE KEYSPACE IF NOT EXISTS manatrends_keyspace
    WITH replication = {
      'class': 'SimpleStrategy',
      'replication_factor': 1
    }
    """
  )
end

# Attempt to connect and create keyspace and table with retries
max_retries = 5
tries = 0

begin
  # Temporary session to create keyspace
  temp_session = cluster.connect()
  create_keyspace(temp_session)
  temp_session.close

  # Now connect to the newly created keyspace
  $session = cluster.connect('manatrends_keyspace') 

  # Ensure table exists
  $session.execute(
    """
      CREATE TABLE IF NOT EXISTS steam_game(
        app_id int PRIMARY KEY,
        name text,
        description text,
        image text,
        developer text
      )
    """
  )

  puts "Connected to ScyllaDB and ensured 'steam_game' table exists."
rescue Cassandra::Errors::NoHostsAvailable => e
  puts "Failed to connect to ScyllaDB: #{e.message}"
  tries += 1
  if tries < max_retries
    puts "Retry ##{tries} in 60 seconds..."
    sleep 60
    retry
  else
    puts "Failed to connect to ScyllaDB after #{max_retries} tries."
    # Handle the final failure as needed (exit, log, etc.)
  end
rescue => e
  puts "An error occurred: #{e.message}"
  # Handle unexpected errors
end


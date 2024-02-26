# config/puma.rb
require 'dotenv'
Dotenv.load

if ENV['RACK_ENV'] == 'development'
  workers 0
  threads 1, 1
else
  workers 4
  threads 5, 10
end

bind "tcp://0.0.0.0:9292"
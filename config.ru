require "./app.rb"
require "rack/timeout"
use Rack::Timeout
Rack::Timeout.timeout = 5
run Sinatra::Application

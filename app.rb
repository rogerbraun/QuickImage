require "rubygems"
require "bundler"
require "open-uri"
require "cgi"

Bundler.require

get "/" do
  "quickimage.heroku.com/keyword"
end

get "/favicon.ico" do
  halt 404
end

get "/:keyword" do
  random_result params["keyword"]
end

def search keyword 
  url = "https://www.google.com/search?q=#{CGI::escape keyword}&tbm=isch"
  results = open(url).read.scan /imgurl=(.+?)&/
end

def random_result keyword 
  res = search keyword 
  pick = res[rand(res.size)].first
  "<img src='#{pick}' />"
end

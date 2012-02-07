require "rubygems"
require "bundler"
require "open-uri"
require "cgi"
require "pry"

Bundler.require

get "/" do
  
  "Geht"
end

get "/favicon.ico" do
  halt 404
end

get "/:keyword" do
  first_result params["keyword"]
end

def search(keyword)
  url = "https://www.google.com/search?q=#{CGI::escape(keyword)}&tbm=isch"
  Nokogiri::HTML(open(url))
end

def first_result(keyword)
  doc = search(keyword)
  doc.css("#ires img").first.to_s
end

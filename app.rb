require "rubygems"
require "bundler"
require "open-uri"
require "cgi"

Bundler.require

get "/" do
  redirect "/index.html"
end

get "/favicon.ico" do
  halt 404
end

get "/image/:key/:width/:height" do
  result = random_result params[:key]
  result_base = File.basename(result)
  x_y = params[:width] + "x" + params[:height]
  filename = params[:key] + "_" + x_y + ".jpg"
  `wget -P tmp #{result}` 
  `convert -resize #{x_y} -extent #{x_y} -gravity center tmp/#{result_base} tmp/#{filename}`
  send_file "tmp/" + filename
end

def search keyword 
  url = "https://www.google.com/search?q=#{CGI::escape keyword}&tbm=isch"
  results = open(url).read.scan /imgurl=(.+?)&/
  results.flatten
end

def random_result keyword 
  res = search keyword 
  pick = res[rand(res.size)]
end

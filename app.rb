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

get "/image/:key/:width/:height/hier" do
  file = get_random_file params[:key]
  file = add_hier file
  send_file file
end

get "/image/:key/:width/:height" do
  file = get_random_file params[:key]
  send_file file
end

def add_hier file
  `composite label:HIER!!!! -gravity center #{file} #{file}_hier.jpg`
  file + "_hier.jpg"
end

def get_random_file keyword
  converted = false
  while not converted do
    result = random_result keyword
    result_base = File.basename(result)
    x_y = params[:width] + "x" + params[:height]
    filename = result_base + "_" + x_y + ".jpg"
    unless File.exists?(File.join("tmp", result_base))
      `wget -P tmp #{result}`
      `convert -resize #{x_y} -extent #{x_y} -gravity center tmp/#{result_base} tmp/#{filename}`
    end
    converted = true if File.exists?(File.join("tmp",filename))
  end

  File.join "tmp", filename
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

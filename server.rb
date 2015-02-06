require 'sinatra'
require 'sinatra/activerecord'
require 'bundler'
Bundler.require

set :public_css, File.dirname("./public/css/**")
set :public_script, File.dirname("./public/script/**")
set :public_images, File.dirname("./public/images/**") 

Dir["./models/**"].each do |model|
  require model
end

class Server < Sinatra::Base 
end

Dir["./controllers/**"].each do |controller|
  require controller
end

Dir["./routes/**"].each do |route|
  require route
end
require 'sinatra'
require './responses.rb'

post '/' do
  request.body.rewind
  json = JSON.parse request.body.read
  api_response=firstResponder(json) 
  Post.create!(request: json, response:api_response) 
  return api_response

  
end

get "/" do
  @posts = Post.order("created_at DESC")
  erb :"posts/index"
end
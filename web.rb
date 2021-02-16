require 'sinatra'
require './responses.rb'

post '/' do
  request.body.rewind
  json = JSON.parse request.body.read
  firstResponder(json)  
  
end
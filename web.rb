require 'sinatra'
require './responses.rb'

post '/' do
  request.body.rewind
  json = JSON.parse request.body.read
  firstResponder(json)  #|| "foo" ||  {}.to_json
  #return json.to_json

end
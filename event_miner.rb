require 'sinatra'
require 'haml'
require 'net/http'

get '/' do
	haml :index
end
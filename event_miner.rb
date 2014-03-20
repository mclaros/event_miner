require 'sinatra'
require 'haml'
require 'net/http'

get '/' do
	haml :index
end

post '/url' do
	begin
		target_uri = URI(params[:url][:address])
		result = Net::HTTP.get(target_uri)
	rescue
		"Please go back and make sure you entered correct url. Ex: 'http://www.google.com'"
	end
end
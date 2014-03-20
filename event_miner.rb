require 'sinatra' #light web framework
require 'haml' #html templating
require 'net/http' #HTTP requests
require 'nokogiri' #HTTP parsing
require './has_event.rb'
require './url_get.rb'

get '/' do
	haml :index
end

get '/url' do
	@url = params[:url][:address]
	@filters_input = params[:filters][:matchers]
	@links_filters_input = params[:filters][:links]

	filters_given = @filters_input.split(/\s+/)
	filters = parse_filters(filters_given)
	@results = search_page(@url, filters)

	#simplest way to notify of error string
	return @results if @results.is_a? String
	haml :results
end
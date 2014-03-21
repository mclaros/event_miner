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
	@links_filters_input = params[:filters][:links] || ""
	@check_links = params[:filters][:check_links]

	filters_given = @filters_input.split(/\s+/)
	word_filters = parse_filters(filters_given)
	link_filters = @links_filters_input.split(",")

	@results = search_page(@url, word_filters, link_filters)

	if @check_links && !@results[:links_found].empty?
		begin
			@results[:checked_links] = assess_links(@results[:links_found], word_filters)
		rescue
			return "Sorry, didn't work. It's a known bug. :("
		end
	end

	#I am using a string to represent any errors found
	return @results if @results.is_a? String

	haml :results
end

get '/about' do
	haml :about
end
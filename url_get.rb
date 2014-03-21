def search_page(url, word_filters, link_filters = nil)
	begin
		uri = URI(url)
		doc = query_url(uri)
	rescue
		return "Please go back and make sure you entered correct url. Ex: 'http://www.google.com'"
	end
	body = doc.css('body') #search by CSS selector
	words = get_body_text(body)
	results = {:words => words}
	results[:matches_found] = text_filter(words, word_filters, uri.to_s)

	if link_filters
		results[:links_found] = grab_links(body, link_filters, uri.host)
	end

	results
end

def query_url(uri)
	result = Net::HTTP.get(uri)
	Nokogiri::HTML(result)
end

def get_body_text(nokogiri_obj)
	text = nokogiri_obj.text.downcase
	text.split(/\W+/)
end

def grab_links(parent_nokogiri_obj, link_filters, root_url)
	links = []

	#in this case, link_filters is an array of
	# terms to compare against
	link_filters.each do |term|
		links.concat links_that_contain(parent_nokogiri_obj, term)
	end

	#these links are Nokogiri objects, so map over them
	# if we want only the URL strings.
	links.map do |link|
		href = link.attribute("href").value
		href.include?(root_url) ? href : (root_url + href)
	end.uniq
end

def links_that_contain(parent_nokogiri_obj, text)
	if text == "*"
		parent_nokogiri_obj.css("a")
	else
		parent_nokogiri_obj.search("a:contains('#{text}')")
	end
end

def assess_links(urls, word_filters)
	checked_links = {}

	urls.each do |url|
		link_filter_results = search_page(url, word_filters)
		match_results = link_filter_results[:matches_found]
		total_matches = match_results[:total_matches]
		total_filters = match_results[:total_filters]

		checked_links[url] = {total_matches: total_matches, total_filters: total_filters}
	end
	checked_links
end
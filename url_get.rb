def search_page(uri, filters)
	begin
		doc = query_url(uri)
	rescue
		return "Please go back and make sure you entered correct url. Ex: 'http://www.google.com'"
	end
	body = doc.css('body') #search by CSS selector
	words = get_body_text(body)
	results = {:words => words}
	results[:matches_found] = text_filter(words, filters, uri.to_s)
	results
end

def query_url(url)
	target_uri = URI(url)
	result = Net::HTTP.get(target_uri)
	Nokogiri::HTML(result)
end


def get_body_text(nokogiri_obj)
	text = nokogiri_obj.text.downcase
	text.split(/\W+/)
end
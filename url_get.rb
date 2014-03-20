def search_page(url, filters)
	begin
		doc = query_url(url)
	rescue
		return "Please go back and make sure you entered correct url. Ex: 'http://www.google.com'"
	end
	body = doc.css('body') #search by CSS selector
	words = get_body_text(body)
	results = {:words => words}
	results.merge(text_filter(words, filters)).inspect
	# results.inspect
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
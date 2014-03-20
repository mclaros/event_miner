def text_filter(words, filters = {})
	#filters will be 
	#	{:filter_name1 => "filter1", :filter_name2 => /filter2/}

	#results will count the number of matches per filter
	results = Hash.new(0)

	words.each do |word|
		filters.each do |filter_name, filter|
			if matches?(word, filter)
				results[filter_name] += 1
			end
		end
	end
	results
end

def matches?(string, filter)
	return string == filter if filter.is_a? String
	return string =~ filter if filter.is_a? Regexp 
end
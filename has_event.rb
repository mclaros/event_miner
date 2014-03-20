CONTENT_TYPES = {
	"day" => %w{
		monday tuesday wednesday thursday friday saturday sunday
		mon tue wed thu fri sat sun
	},
	"time_12_hour" => /([0-1]?[0-9]):([0-5][0-9])/,
	"time_24_hour" => /([0-2]?[0-9]):([0-5][0-9])/
}

def text_filter(words, filters = {})
	#filters will be 
	#	{:filter_name1 => "filter1", :filter_name2 => /filter2/}

	#results will count the number of matches per filter
	filter_hit_count = Hash.new(0)

	words.each do |word|
		filters.each do |filter_name, filter|
			next if filter.nil?

			if matches?(word, filter)
				filter_hit_count[filter_name] += 1
			end
		end
	end
	filter_hit_count
end

def matches?(string, filter)
	return string == filter if filter.is_a? String
	return string =~ filter if filter.is_a? Regexp
	return filter.include? string if filter.is_a? Array
end

def parse_filters(filter_form_input)
	filters = {:length => 0}

	filter_form_input.each do |line|
		filter_type, filter_matcher = line.chomp.split(":")
		case filter_type
		when "word"
			filters[filter_matcher + "_word"] = filter_matcher
		when "regexp"
			filters[filter_matcher[1..-1] + "_regexp"] = Regexp.new(filter_matcher[1..-1])
		when "has_type"
			filters[filter_matcher + "_has_type"] = CONTENT_TYPES[filter_matcher]
		when "within_url"
			if (filter_matcher[0] == "/") & (filter_matcher[-1] == "/")
				#format is /regexp/
				filter_matcher = Regexp.new(filter_matcher[1..-2])
			end
			filters[filter_matcher + "_within_url"] = filter_matcher
		end
		filters[:length] += 1
	end

	filters
end
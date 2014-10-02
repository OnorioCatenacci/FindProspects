defmodule Findprospects do
	@cse_id "013762905797904918430:uayxiyco3la"
	@api_key "AIzaSyDsCVjVErapNdDkG5ndv5lwAE9bCM7a-l4"
	@query_string "employee%20benefits%20fair%20-plan%20-planning"
	@default_date_range "w4" #Last 4 weeks
	@initial_search_index 1
  
	@cse_rest_base "https://www.googleapis.com/customsearch/v1?key=#{@api_key}&cx=#{@cse_id}&q=#{@query_string}&dateRestrict=#{@default_date_range}"

	def get_custom_search_results(initial_index) do
		get_next_ten_search_results(initial_index)
		|> decode_json_results
		|> get_items
	end

	defp get_next_ten_search_results(starting_index) do
		HTTPotion.start()
		HTTPotion.get("#{@cse_rest_base}&start=#{starting_index}")
	end
		
	defp decode_json_results(raw_result) do
		:jsx.decode(raw_result.body)
	end

	defp get_items(json_results) do
		[_kind | _t] = json_results
		[_url | _t] = _t
		[_queries | _t] = _t
		[_context | _t] = _t
		[_search_information | _t] = _t
		[{_,items}] = _t
		items
	end

	defp parse_individual_item(item) do
		[_kind | _t] = item
		[_title | _t] = _t
		[{"htmlTitle",_htmlTitle} | _t] = _t
		[{"link",_link} | _t] = _t
		[_displayLink | _t] = _t
		[{"snippet",_snippet} | _t] = _t
		[_htmlSnippet | _t] = _t
		[{"cacheId",_cacheId} | _t] = _t
		[_formattedUrl | _t] = _t
		[_htmlFormattedUrl | _t] = _t
		[_pagemap | _t] = _t
		{_htmlTitle,_snippet,_link,_cacheId}
	end
end

defmodule Findprospects do
	@cse_id "013762905797904918430:uayxiyco3la"
	@api_key "AIzaSyDsCVjVErapNdDkG5ndv5lwAE9bCM7a-l4"
	@query_string "employee%20benefits%20fair%20-plan%20-planning"
	@default_date_range "w4" #Last 4 weeks
	@default_result_name "test.csv"
	@initial_search_index 1
  
	@cse_rest_base "https://www.googleapis.com/customsearch/v1?key=#{@api_key}&cx=#{@cse_id}&q=#{@query_string}&dateRestrict=#{@default_date_range}"

	def get_custom_search_results(initial_index) do
		l = get_next_ten_search_results(initial_index)
		|> decode_json_results
		|> get_items
		|> Stream.map(&(parse_individual_item/1))
		
		csv_file = open_csv_file(@default_result_name)
		Enum.each(l, &create_csv_record(&1, csv_file))
		close_csv_file(csv_file)
	end

	def get_next_ten_search_results(starting_index) do
		HTTPotion.start()
		HTTPotion.get("#{@cse_rest_base}&start=#{starting_index}")
	end
		
	def decode_json_results(raw_result) do
		:jsx.decode(raw_result.body)
	end

	defp get_items( [{"items",items} | _ ]), do: items
	defp get_items([_h | json_results]), do: get_items(json_results)
	defp get_items([]), do: []

# Code that I'm working on--not ready yet but don't want to lose it either. 3 October 2014
#	defp get_json_element([{element_to_get,value_of_element} | _t]), do: _value_of_element
#	defp get_json_element([_h | _t]), do: get_json_element(_t)
#	defp get_json_element([]), do: ""


	defp get_html_title([{"htmlTitle",_html_title} | _t]), do: _html_title
	defp get_html_title([_h | _t]), do: get_html_title(_t)
	defp get_html_title([]), do: ""

	defp get_link([{"link",_link} | _t]), do: _link
	defp get_link([_h | _t]), do: get_link(_t)
	defp get_link([]), do: ""

	defp get_snippet([{"snippet",_snippet} | _t]), do: _snippet
	defp get_snippet([_h | _t]), do: get_snippet(_t)
	defp get_snippet([]), do: ""

	defp get_cache_id([{"cacheId",_cache_id} | _t]), do: _cache_id
	defp get_cache_id([_h | _t]), do: get_cache_id(_t)
	defp get_cache_id([]), do: ""

	defp parse_individual_item(item) do 
		{
		 _html_title = get_html_title(item),
		 _snippet = get_snippet(item),
     _link = get_link(item),
		 _cache_id = get_cache_id(item)
		 }
	end

	defp open_csv_file(filename) do
		temp_dir = System.get_env("Temp")
		file = File.open!("#{temp_dir}/#{filename}",[:append])
	end

	defp close_csv_file(filename), do: File.close(filename)

	defp create_csv_record(item, result_file) do
		{html_title,snippet,link,cache_id} = item
		IO.puts(result_file, "#{html_title} , #{link} , #{cache_id}\n")
	end

end

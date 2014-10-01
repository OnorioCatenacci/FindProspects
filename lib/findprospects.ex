defmodule Findprospects do
  @cse_id "013762905797904918430:uayxiyco3la"
  @api_key "AIzaSyDsCVjVErapNdDkG5ndv5lwAE9bCM7a-l4"
  
	@cse_rest_base_url "https://www.googleapis.com/customsearch/v1?key=#{@api_key}&cx=#{@cse_id}&q=employee%20benefits%20fair%20-plan%20-planning"

	def get_custom_search_results do
		HTTPotion.start()
		results = HTTPotion.get("#{@cse_rest_base_url}")
		decoded_results = :jsx.decode(results.body)
	end
end

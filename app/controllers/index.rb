get '/' do
  erb :index
end

post '/recipes' do
  search_string = params[:search]
  @result = Yummly.search(search_string, :maxResult => 20)
  @result_total = @result.matches.size

  erb :index
end

get '/recipes/:result_id' do
  params[:result_id] 
  @recipe = Yummly.find(params[:result_id])

  erb :recipe
end

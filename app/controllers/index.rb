get '/' do
 redirect '/recipes' 
end

post '/recipes' do
  search_string = params[:search]
  @result = Yummly.search(search_string, :maxResult => 20)
  @result_total = @result.matches.size

  @saved_recipes = Recipe.all
  erb :index
end

get '/recipes/:result_id' do
  @recipe = Yummly.find(params[:result_id])

  erb :recipe
end

post '/recipes/:result_id' do
  recipe = Yummly.find(params[:result_id])

  saved_recipe = Recipe.new(name: recipe.name, yummly_id: recipe.id, ingredients: recipe.ingredients)

  if saved_recipe.save
    redirect '/'
  else
    status 400
  end
end

get '/' do
  redirect '/recipes' 
end

get '/recipes' do
  if params[:search]
    @result = Yummly.search(params[:search], :maxResult => 20)
  else
    @result = Yummly.search("Eggplant", :maxResult => 20)
  end

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

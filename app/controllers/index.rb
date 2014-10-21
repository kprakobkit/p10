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

get '/recipes/:recipe_id' do
  @recipe = Yummly.find(params[:recipe_id])

  erb :recipe
end

post '/recipes' do
  recipe = Yummly.find(params[:recipe_id])

  saved_recipe = Recipe.new(name: recipe.name, yummly_id: recipe.id, ingredients: recipe.ingredients)

  if saved_recipe.save
    redirect '/'
  else
    status 400
  end
end

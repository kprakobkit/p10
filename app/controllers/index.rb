get '/' do
  redirect '/recipes'
end

get '/recipes' do
  if params[:search]
    @result = Yummly.search(params[:search], :maxResult => 20, :requirePictures => true)
  else
    @result = Yummly.search("Eggplant", :maxResult => 20, :requirePictures => true)
  end

  @saved_recipes = Recipe.all
  erb :index
end

get '/recipes/:recipe_id' do
  if Recipe.find_by(yummly_id: params[:recipe_id])
    p @recipe = Recipe.find_by(yummly_id: params[:recipe_id])
    @from_db = true
  else
    p @recipe = Yummly.find(params[:recipe_id])
    @from_db = false
  end

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

post '/recipes/:recipe_id/email' do
  recipe = Yummly.find(params[:recipe_id])
  email = params[:email]
  @ingredients = recipe.ingredients.uniq
  subject = "Recipe for: #{recipe.name}"
  send_email(email, subject, 10)
end

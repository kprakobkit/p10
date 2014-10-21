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

post '/recipes/:recipe_id/email' do
  recipe = Yummly.find(params[:recipe_id])
  email = params[:email]
  @ingredients = recipe.ingredients.uniq
  subject = "Recipe for: #{recipe.name}"

  Pony.mail(:to => email,
            :from => email,
            :subject => subject,
            :html_body => erb(:email, layout: false))

  redirect "recipes/#{recipe.id}"
end

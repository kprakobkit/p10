get '/' do
  redirect '/recipes'
end

get '/recipes' do
  if params[:search]
    @result = Yummly.search(params[:search], :maxResult => 20, :requirePictures => true)
  else
    @result = nil
  end

  @scheduled_recipes = Recipe.all.order(:scheduled_at)
  erb :index
end

get '/recipes/:recipe_id' do
  if Recipe.find_by(yummly_id: params[:recipe_id])
    @recipe = Recipe.find_by(yummly_id: params[:recipe_id])
    @from_db = true
  else
    @recipe = Yummly.find(params[:recipe_id])
    @from_db = false
  end

  erb :recipe
end

post '/recipes/schedule' do
  recipe = Yummly.find(params[:recipe_id])

  scheduled_at = (Time.parse params[:date]) + (60 * 60 * 19)
  saved_recipe = Recipe.new(name: recipe.name, yummly_id: recipe.id, ingredients: recipe.ingredients, scheduled_at: scheduled_at)

  if saved_recipe.save
    @ingredients = recipe.ingredients.uniq
    subject = "Recipe for: #{recipe.name}"
    send_email(params[:email], subject, scheduled_at)
    redirect '/'
  else
    status 400
  end
end

post '/recipes/delete/:yummly_id' do
  content_type :json
  recipe = Recipe.find_by(yummly_id: params[:yummly_id])
  recipe.destroy

  {yummly_id: recipe.yummly_id}.to_json
end

get '/scheduled_meals' do
  @scheduled_meals = {}

  days_in_week.each do |day|
    @scheduled_meals[day] = Recipe.all.select do |recipe|
      recipe.scheduled_date == day
    end
  end

   erb :scheduled_meals
end

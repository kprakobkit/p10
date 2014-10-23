get '/' do
  # erb :main, :layout => false
  redirect '/recipes'
end

get '/recipes' do
  if params[:search]
    @result = Yummly.search(params[:search], :maxResult => 20, :requirePictures => true)
    @search_term = params[:search]
    @page_number = 0
  else
    @result = nil
  end

  erb :index
end

get '/recipes/:search_query/:page_number' do
  if params[:search_query]
    @page_number = params[:page_number].to_i + 1
    @result = Yummly.search(params[:search_query], :maxResult => 20, :start => @page_number *  20, :requirePictures => true)
    @search_term = params[:search_query]
  else
    @result = nil
  end

  erb :index
end

get '/recipes/:recipe_id' do
  recipe = Yummly.find(params[:recipe_id])
  @image_url = recipe.images.first.large_url
  @source_url = recipe.attribution.url
  if Recipe.find_by(yummly_id: params[:recipe_id])
    @recipe = Recipe.find_by(yummly_id: params[:recipe_id])
    @from_db = true
  else
    @recipe = recipe
    @from_db = false
  end
  erb :recipe
end

post '/recipes/schedule' do
  recipe = Yummly.find(params[:recipe_id])

  scheduled_at = (Time.parse params[:date])
  saved_recipe = Recipe.new(name: recipe.name, yummly_id: recipe.id, ingredients: recipe.ingredients, scheduled_at: scheduled_at)

  if saved_recipe.save
    @ingredients = recipe.ingredients.uniq
    subject = "Recipe for: #{recipe.name}"
    send_email(params[:email], subject, scheduled_at)
    redirect '/recipes'
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

get '/scheduled_meals/:week_start_date' do
  @week_start_date = (Date.parse params[:week_start_date]).beginning_of_week
  @meals_for_the_week = get_meals_per_week(@week_start_date)

  erb :scheduled_meals
end

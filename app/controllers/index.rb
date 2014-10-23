get '/' do
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

get '/recipes/:recipe_id' do
  @image_url = Yummly.find(params[:recipe_id]).images.first.large_url
  if Recipe.find_by(yummly_id: params[:recipe_id])
    @recipe = Recipe.find_by(yummly_id: params[:recipe_id])
    @from_db = true
  else
    @recipe = Yummly.find(params[:recipe_id])
    @from_db = false
  end
  erb :recipe
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

post '/recipes/schedule' do
  recipe = Yummly.find(params[:recipe_id])

  scheduled_at = (Time.parse params[:date])
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

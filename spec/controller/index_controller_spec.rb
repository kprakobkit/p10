require_relative '../spec_helper'

describe :Controller do
  before (:all) do
    Recipe.delete_all
  end
  context "get /recipes" do
    before (:each) do
      recipe = Yummly.find('Grilled-marinated-eggplant-315336')
      Recipe.create(name: recipe.name, yummly_id: recipe.id, ingredients: recipe.ingredients, scheduled_at: Time.now)
    end

    it "should display all saved recipes" do
      get '/recipes'
      saved_recipe_name = Recipe.all.map { |recipe| recipe.name }
      saved_recipe_name.each do |recipe_name|
        expect(last_response.body).to include(recipe_name)
      end
    end
  end

  context "post 'recipes/schedule' " do

    it "should save a recipe" do
      recipe = Yummly.find('Grilled-marinated-eggplant-315336')

      expect {
        post '/recipes/schedule', {recipe_id: recipe.id, date: "2014-10-22"}
      }.to change{ Recipe.count }.by(1)
    end
  end
end

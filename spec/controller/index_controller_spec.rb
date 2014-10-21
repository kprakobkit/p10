require_relative '../spec_helper'

describe :Controller do
  before (:all) do
    Recipe.delete_all
  end
  context "get /recipes" do
    before (:each) do
      recipe = Yummly.find('Grilled-marinated-eggplant-315336')
      Recipe.create(name: recipe.name, yummly_id: recipe.id, ingredients: recipe.ingredients)
    end

    it "should display all saved recipes" do
      get '/recipes'
      saved_recipe_name = Recipe.all.map { |recipe| recipe.name }
      saved_recipe_name.each do |recipe_name|
        expect(last_response.body).to include(recipe_name)
      end
    end
  end

  context "post 'recipes/:recipe_id' " do

    it "should save a recipe" do
      recipe = Yummly.find('Grilled-marinated-eggplant-315336')

      expect {
        post '/recipes', {recipe_id: recipe.id}
      }.to change{ Recipe.count }.by(1)
    end
  end
end

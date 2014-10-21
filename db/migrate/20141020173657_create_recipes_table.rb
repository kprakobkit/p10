class CreateRecipesTable < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.text :ingredients
      t.timestamps 
    end
  end
end

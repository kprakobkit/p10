class CreateRecipesTable < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name, :yummly_id
      t.text :ingredients
      t.timestamps 
    end
  end
end

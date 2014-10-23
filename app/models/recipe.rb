class Recipe < ActiveRecord::Base
  serialize :ingredients

  def scheduled_date
    Date.parse self.scheduled_at.to_s
  end

  def self.get_yummly_ids
    @yummly_ids = Recipe.all.map { |recipe| recipe.yummly_id }
  end
end

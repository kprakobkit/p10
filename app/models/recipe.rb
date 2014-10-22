class Recipe < ActiveRecord::Base
  serialize :ingredients

  def scheduled_date
    Date.parse self.scheduled_at.to_s
  end
end

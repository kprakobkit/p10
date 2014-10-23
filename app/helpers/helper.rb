helpers do
  def send_email(email, subject, scheduled_at)
    scheduler = Rufus::Scheduler.new
    email_time = scheduled_at + (60 * 60 * 2)
    scheduler.at email_time do
      Pony.mail(:to => email,
                :from => email,
                :subject => subject,
                :html_body => erb(:email, layout: false))
    end
  end

  def get_meals_per_week(week_start_date)
    days_in_week = (week_start_date.beginning_of_week..week_start_date.end_of_week).to_a
    meals_for_the_week = {}
    days_in_week.each do |day|
      meals_for_the_week[day] = Recipe.all.select do |recipe|
        recipe.scheduled_date == day
      end
    end
    meals_for_the_week
  end

  def all_yummly_ids
    yummly_ids = Recipe.get_yummly_ids
  end
end

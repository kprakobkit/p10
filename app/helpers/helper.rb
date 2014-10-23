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

  def days_in_week(start_date)
    (start_date.beginning_of_week..start_date.end_of_week).to_a
  end

  def all_yummly_ids
    @yummly_ids = Recipe.get_yummly_ids
  end
end

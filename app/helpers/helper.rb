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

  def days_in_week
    days_in_week = (0..6).map do
      |n| Date.today.beginning_of_week + n
    end
    days_in_week
  end
end

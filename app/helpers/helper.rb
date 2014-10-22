helpers do
  def send_email(email, subject, time)
    scheduler = Rufus::Scheduler.new
    scheduler.at time do
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

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
end

module MyScheduler
  def self.scheduler
    @scheduler ||= Rufus::Scheduler.new
  end
end

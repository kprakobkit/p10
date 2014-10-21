helpers do
  def send_email(email, subject, time)
    time_to_send = Time.now + time 
    scheduler = Rufus::Scheduler.new
    scheduler.in time_to_send do
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
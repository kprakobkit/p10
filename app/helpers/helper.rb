helpers do
  def send_email(email, subject)
    time = Time.now + 2
    scheduler = Rufus::Scheduler.new
    scheduler.in '2s' do
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

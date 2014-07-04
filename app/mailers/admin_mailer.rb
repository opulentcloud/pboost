class AdminMailer < ActionMailer::Base
  default from: ENV['ADMIN_EMAIL_FROM']
  default bcc: ENV['ADMIN_EMAIL_BCC']
  
  def notification(subject, message)
    @message = message
    subject = "#{Rails.env.staging? ? '[staging]' : ''}#{subject}"
  	to = ENV['ADMIN_EMAIL_TO']
  	mail(to: to, subject: subject)
  end  
end

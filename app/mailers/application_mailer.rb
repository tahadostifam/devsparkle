class ApplicationMailer < ActionMailer::Base
  default from: 'devsparkle.dot.ir@gmail.com'
  layout 'mailer'

  def welcome_email
    @user = params[:user]
    @url  = 'http://127.0.0.1:3000/email_confirm'
    mail(to: @user.email, subject: 'devsparkle.ir به خوش آمدید')
  end
end

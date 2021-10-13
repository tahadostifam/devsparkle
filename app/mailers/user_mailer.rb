class UserMailer < ApplicationMailer
    default from: 'devsparkle.dot.ir@gmail.com'
    layout 'mailer'

    def send_confirm_account
        @user = params[:user]
        @url  = "http://127.0.0.1:3000/users/confirm_account/#{@user.confirm_token}"
        mail(to: @user.email, subject: 'devsparkle.ir | لینک تایید ایمیل')
    end

    def send_forgot_password
        @user = params[:user]
        @url  = "http://127.0.0.1:3000/users/forgot_password_set_new/#{@user.forgot_password_token}"
        mail(to: @user.email, subject: 'devsparkle.ir | فراموشی گذرواژه')
    end
end

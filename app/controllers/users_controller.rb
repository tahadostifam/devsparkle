class UsersController < ApplicationController
  def submit_signup
    unless actions_that_have_recaptcha("signup_errors_list")
      redirect_to '/users/signup'
    else
      @user = User.new(user_params)
      if @user.save
        UserMailer.with(user: @user).send_confirm_account.deliver_later

        flash[:success_signup] = true
        flash[:signup_errors_list] = nil
        redirect_to action: 'signup'
      else
        flash[:success_signup] = false
        flash[:signup_errors_list] = @user.errors.full_messages
        redirect_to action: 'signup'
      end
    end
  end

  def confirm_account
    if params.permit(:token).present?
      user = User.find_by(confirm_token: params[:token])
      if user
        user.email_activate

        flash[:account_confirmed] = true
        render 'users/confirm_account_view'
      else
        render 'users/confirm_account_view'
        flash[:account_confirmed] = false
      end
    end
  end

  def signup
    github_api = GithubApi.new

    @user = User.new
    
    render :signup, :locals => { :github_clientid => github_api.clientid }
  end
  
  def signup_with_github
    # github button
    redirect_to 'https://github.com/login/oauth/authorize?client_id=' + params[:clientid]
  end

  def signup_with_github_callback
    # form

    github_api = GithubApi.new

    user_info = github_api.fetch_github params['code']

    if user_info.present?
      @user = User.new
      unless user_info['email'].present?
        return render :signup_with_github_finished, :locals => { nil_email: true, um_used: false }
      end
      @user.email = user_info['email']
      @user.username = user_info['login']
      check_email_and_username_quniqness = User.where(username: @user.username, email: @user.email).first
      if check_email_and_username_quniqness != nil
        return render :signup_with_github_finished, :locals => { nil_email: false, um_used: true }  
      end
      @user.full_name = user_info['name']
      rdnpss = SecureRandom.alphanumeric(15)
      @user.password = rdnpss
      @user.password_confirmation = rdnpss
      @user.email_confirmed = true

      if @user.save
        session[:user] = @user
        render :signup_with_github_finished, :locals => { nil_email: false, um_used: false }
      else
        redirect_to '/500'
      end
    else
      redirect_to action: :signup
    end
  end

  def signin
    @user = User.new
  end

  def submit_signin
    unless actions_that_have_recaptcha("signin_errors_list")
      redirect_to '/users/signin'
    else
      @user = User.find_by(username: signin_params['username'])
      if @user.present? && @user.authenticate(signin_params['password'])
        if @user.email_confirmed?
          session[:user] = @user
          redirect_to root_path
        else
          flash[:signin_errors_list] = [
            "ایمیل شما تایید نشده است... ورود به اکانت امکان پذیر نمی باشد."
          ]
          redirect_to action: 'signin'
        end
      else
        flash[:signin_errors_list] = [
          "نام کاربری یا گذرواژه شما صحیح نمی باشد"
        ]
        redirect_to action: 'signin'
      end
    end
  end

  def logout
    session[:user] = nil
    redirect_to root_path
  end

  def forgot_password
  end

  def terms_and_conditions
    @setting = Setting.first
  end

  private

  def actions_that_have_recaptcha(flash_name)
    gr_response = params["g-recaptcha-response"]
    if gr_response != nil && gr_response.strip != ""
      gr = Grecaptcha.new
      api_result = gr.verify_recaptcha(gr_response, request.remote_ip)
      if api_result == false
        flash[flash_name] = ["ریکپچا را تایید کنید."]
        return false
      else
        return true
      end
    else
      flash[flash_name] = ["ریکپچا را تایید کنید."]
      return false
    end
	end

  def complete_signup_with_github_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def signin_params
    params.require(:user).permit(:username, :password)
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :username, :password, :password_confirmation, :accept_terms_and_conditions)
  end
end

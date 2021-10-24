class ApplicationController < ActionController::Base
	before_action :check_user_before_action

	private

	def check_user_before_action
		if session[:user].present?
			user = User.find_by(id: session[:user]['id'])
			do_user_auth_action(user)
		elsif cookies.signed[:user_id].present?
			user = User.find_by(id: cookies.signed[:user_id])
			do_user_auth_action(user)
			puts 'cookieeeeeee'
		else
			user = nil
		end
	end

	def do_user_auth_action(user)
		if user.present? && user.email_confirmed? && user.is_banned == false
			session[:user] = user
		else
			session[:user] = nil
		end
	end
end

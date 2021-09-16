class ApplicationController < ActionController::Base
    before_action :check_user_before_action

	private

	def check_user_before_action
		if session[:user].present?
			user = User.find_by(id: session[:user]['id'])
			if user.present?
				session[:user] = user
			else
				session[:user] = nil
			end
		end
	end
end

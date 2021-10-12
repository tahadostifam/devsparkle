class ApplicationController < ActionController::Base
	before_action :check_user_before_action

	private

	def check_user_before_action
		if session[:user].present?
			user = User.find_by(id: session[:user]['id'])
			if user.present? && user.email_confirmed?
				session[:user] = user
				@articles_that_not_verified_length = Article.where(published: false, draft: false).length
			else
				session[:user] = nil
			end
		end
	end
end

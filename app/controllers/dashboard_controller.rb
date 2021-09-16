class DashboardController < ApplicationController
  before_action :require_login

  def index
  end

  private

  def require_login
    unless session[:user].present?
      redirect_to '/users/signin'
    end
  end
end

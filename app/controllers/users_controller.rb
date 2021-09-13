class UsersController < ApplicationController
  def signup
    @user = User.new(user_params)


  end

  def signin
  end

  def forgot_password
  end

  def terms_and_conditions
  end

  private

  def user_params
    
  end
end

class CourseEpisodesController < ApplicationController
  before_action :need_owner_access, only: []
  before_action :need_admin_access, only: [:index, :new_episode, :submit_new_episode]

  def index
    @course = Course.find_by(slug: params[:slug])
    unless @course.present?
      redirect_to '/404'
    end
  end

  def show
  end

  def new_episode
    @course = Course.find_by(slug: params[:slug])
    unless @course.present?
      redirect_to '/404'
    else
      @episode = CourseEpisode.new
    end
  end

  def submit_new_episode
    
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

  def need_owner_access
    unless session[:user].is_owner?
      redirect_to '/503'
    end
  end

  def need_admin_access
    unless session[:user].is_admin?
      redirect_to '/503'
    end
  end
end

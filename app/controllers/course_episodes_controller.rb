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

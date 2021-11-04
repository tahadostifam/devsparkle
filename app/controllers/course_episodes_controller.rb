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
    @course = Course.find_by(slug: new_episode_params[:slug])
    unless @course.present?
      return redirect_to '/404'
    end
    if (@course.user_id == session[:user][:id]) || (session[:user][:is_owner])
      unless session[:user][:is_owner]
        new_episode_params[:published] = false
      end

      @episode = CourseEpisode.new(new_episode_params)
      @episode.course_id = @course.id
      if @episode.save
        render 'episode_created'
      else
        flash[:new_episode_errors] = @episode.errors.full_messages
        render 'new_episode'
      end
    else
      redirect_to '/503'
    end
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

  def new_episode_params
    params.require(:course_episode).permit(:slug, :header, :cover_text, :published, :video_file)
  end
end

class CourseEpisodesController < ApplicationController
  def index
    @course = Course.find_by(slug: params[:slug])
    unless @course.present?
      redirect_to '/404'
    end
  end

  def show
  end
end

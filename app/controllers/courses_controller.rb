class CoursesController < ApplicationController
  def index
    @courses = Course.where(published: true)
  end

  def show
    @course = Course.find_by(slug: params[:slug])
    @setting = Setting.first
    # @comment = Comment.new
    if @course.present?
      # @comments = @course.comments.order("created_at DESC").all
      if session[:user] != nil
        if @course.user_id == session[:user][:id] || session[:user][:is_owner]
          return render :show, :locals => { :show_actions => true }
        end
      end
      if (@course.published? == false)
        @course = nil
      end
      render :show, :locals => { :show_actions => false }
    end
  end
end

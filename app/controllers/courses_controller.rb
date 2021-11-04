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
        @youre_member_of_this_course = CourseMember.find_by(user_id: session[:user][:id], course_id: @course.id)
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

  def join_at_course
    @course = Course.find_by(slug: params[:slug])
    if @course.present?
      user = session[:user]
      if user != nil
        if (!user[:is_owner] && !user[:is_admin]) && !CourseMember.find_by(user_id: session[:user][:id], course_id: @course.id)
          member = CourseMember.new(user_id: session[:user][:id], course_id: @course.id)
          if member.valid?
            member.save!
            redirect_to '/courses/show/' + @course.slug
          else
            redirect_to '/500'
          end
        else
          redirect_to '/503'    
        end
      end
    else
      redirect_to '/404'
    end
  end

  def confirm_delete_course
    @course = Course.find_by(slug: params[:slug])
    if @course.nil?
      redirect_to action: :index
    end
  end

  def submit_delete_course
    slug = params[:slug]
    co = Course.find_by(slug: slug)
    if co.present?
      if session[:user].present? && session[:user][:is_owner] || co.user_id == session[:user][:id]
        co.course_likes.destroy_all
        # co.comments.destroy_all
        co.image.destroy
        co.destroy
        render 'course_deleted'
      else
        redirect_to '/503'
      end
    else
      redirect_to action: :index
    end
  end
end

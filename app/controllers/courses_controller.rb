class CoursesController < ApplicationController
  def index
    @courses = Course.where(published: true)
  end

  def show
  end
end

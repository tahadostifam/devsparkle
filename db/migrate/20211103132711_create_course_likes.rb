class CreateCourseLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :course_likes do |t|
      t.references :user
      t.references :course
    end
  end
end

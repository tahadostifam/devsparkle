class CreateCourseMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :course_members do |t|
      t.references :user
      t.references :course
      t.timestamps
    end
  end
end

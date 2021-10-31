class CreateCourseMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :courses_users do |t|
      t.references :user
      t.references :course
      t.timestamps
    end
  end
end
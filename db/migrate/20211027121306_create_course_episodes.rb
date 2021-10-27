class CreateCourseEpisodes < ActiveRecord::Migration[6.1]
  def change
    create_table :course_episodes do |t|
      t.string :slug, unique: true, null: false, foreign_key: true
      t.string :header, null: false, foreign_key: true
      t.text :cover_text
      t.boolean :published, default: false
      t.references :course
      t.timestamps
    end
  end
end

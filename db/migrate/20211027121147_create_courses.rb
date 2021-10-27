class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :slug, unique: true, null: false, foreign_key: true
      t.string :header, null: false, foreign_key: true
      t.text :cover_text
      t.boolean :published, default: false
      t.string :published_time
      t.references :user
      t.timestamps
    end
  end
end

class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :slug, unique: true, null: false, foreign_key: true
      t.string :header, null: false, foreign_key: true
      t.text :content, null: false
      t.text :cover_text
      t.boolean :published, default: false
      t.string :published_time
      t.boolean :draft, default: false
      t.references :user
      t.timestamps
    end
  end
end

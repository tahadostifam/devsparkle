class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.text :slug, unique: true, null: false
      t.string :header, null: false
      t.text :content, null: false
      t.text :cover_text
      t.boolean :published, default: false
      t.integer :visit_count, default: 0
      t.references :user
      t.timestamps
    end
  end
end

class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :slug, unique: true, null: false
      t.string :header, null: false
      t.text :content, null: false
      t.text :cover_text
      t.boolean :published, default: false
      t.string :published_time, default: Date.today.to_pdate.strftime("%Y/%m/%d")
      t.boolean :draft, default: false
      t.integer :visit_count, default: 0
      t.references :user
      t.timestamps
    end
  end
end

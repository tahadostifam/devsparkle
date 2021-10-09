class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, null: false
      t.references :article, foreign_key: true, null: false
      t.string :content, null: false
      t.string :send_time, null: false
      t.string :hash_id, unique: true, null: false
      t.timestamps
    end
  end
end

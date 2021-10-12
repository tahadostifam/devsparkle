class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false
      t.references :article, null: false
      t.string :content, null: false
      t.string :send_time, null: false
      t.string :hash_id, unique: true, null: false, foreign_key: true
      t.boolean :accept_by_admin, default: false
      t.timestamps
    end
  end
end

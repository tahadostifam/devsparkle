class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email, null: false, unique: true, foreign_key: true
      t.string :username, null: false, unique: true, foreign_key: true
      t.string :password_digest, null: false
      t.boolean :email_confirmed, :default => false
    
      t.text :bio
      t.string :gender
      t.string :website

      t.boolean :is_owner, default: false
      t.boolean :is_admin, default: false
      t.boolean :is_banned, default: false

      t.string :confirm_token, foreign_key: true
      t.string :forgot_password_token, foreign_key: true
      t.string :forgot_password_expire_time, foreign_key: true

      t.timestamps
    end
  end
end

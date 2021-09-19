class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email, null: false, unique: true
      t.string :username, null: false, unique: true
      t.string :password_digest, null: false
      t.boolean :email_confirmed, :default => false
      t.string :confirm_token
      t.text :bio
      t.string :gender
      t.string :website

      t.boolean :is_owner, default: false
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end

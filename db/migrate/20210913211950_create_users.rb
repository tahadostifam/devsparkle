class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email, null: false, unique: true
      t.string :username, null: false, unique: true
      t.string :password_digest, null: false
      t.boolean :email_confirmed, :default => false
      t.string :confirm_token
      t.timestamps
    end
  end
end

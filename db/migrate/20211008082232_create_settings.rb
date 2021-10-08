class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.string :about_us
      t.boolean :can_comment
    end
  end
end

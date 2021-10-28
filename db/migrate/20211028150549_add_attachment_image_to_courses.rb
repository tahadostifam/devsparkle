class AddAttachmentImageToCourses < ActiveRecord::Migration[6.1]
  def up
    add_column :courses, :image_file_name, :string
    add_column :courses, :image_file_size, :integer
    add_column :courses, :image_content_type, :string
    add_column :courses, :image_updated_at, :datetime
  end

  def down
    remove_column :courses, :image_file_name, :string
    remove_column :courses, :image_file_size, :integer
    remove_column :courses, :image_content_type, :string
    remove_column :courses, :image_updated_at, :datetime
  end
end

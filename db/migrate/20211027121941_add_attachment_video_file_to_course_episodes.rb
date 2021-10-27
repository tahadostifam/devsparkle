class AddAttachmentVideoFileToCourseEpisodes < ActiveRecord::Migration[6.1]
  def up
    add_column :course_episodes, :video_file_file_name, :string
    add_column :course_episodes, :video_file_file_size, :integer
    add_column :course_episodes, :video_file_content_type, :string
    add_column :course_episodes, :video_file_updated_at, :datetime
  end

  def down
    remove_column :course_episodes, :video_file_file_name, :string
    remove_column :course_episodes, :video_file_file_size, :integer
    remove_column :course_episodes, :video_file_content_type, :string
    remove_column :course_episodes, :video_file_updated_at, :datetime
  end
end

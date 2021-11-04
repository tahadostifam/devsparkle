class CourseEpisode < ApplicationRecord
    belongs_to :course

    has_attached_file :video_file,
    {
        :storage => :ftp,
        :path => ENV["FTP_UPLOAD_PATH"],
        :url => ENV["FTP_DOWNLOAD_URL"],
        :ftp_servers => [
            {   
                :host => ENV["FTP_HOST"],
                :user => ENV["FTP_USER"],
                :password => ENV["FTP_PASS"],
                passive: true
            }
        ],
        :ftp_ignore_failing_connections => true,
        :ftp_keep_empty_directories => true
    }

    validates_attachment_content_type :video_file, content_type: /\Avideo\/.*\z/
end

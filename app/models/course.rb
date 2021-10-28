class Course < ApplicationRecord
    has_many :course_episodes
    belongs_to :user

    has_attached_file :image,
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
end

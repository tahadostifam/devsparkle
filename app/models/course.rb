class Course < ApplicationRecord
    include Slug
    include PersianDate

    before_create :handle_auto_params_create
    before_update :handle_auto_params_update

    has_many :course_episodes
    has_many :user
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

    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

    validates_presence_of :header, :cover_text, :price
    validates_presence_of :image, on: :create

    private

    def handle_auto_params_update
        self.slug = make_slug(self.header).to_s
    end

    def handle_auto_params_create
        self.slug = make_slug(self.header).to_s
        self.published_time = pdate_today
    end
end

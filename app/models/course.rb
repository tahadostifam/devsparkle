class Course < ApplicationRecord
    include Slug
    include PersianDate

    has_many :course_episodes
    belongs_to :user
    has_many :course_members
    has_many :users, through: :course_members
    has_many :course_likes

    before_create :handle_auto_params_create
    before_update :handle_auto_params_update

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

    def liked(uid)
        return self.course_likes.select { |l| l.user_id == uid && l.course_id == self.id }.length > 0
    end

    def like(aid, uid)
        l = CourseLike.new(course_id: aid, user_id: uid)
        l.save!
    end

    def unlike(aid, uid)
        l = CourseLike.find_by(course_id: aid, user_id: uid)
        l.delete
    end

    private

    def handle_auto_params_update
        self.slug = make_slug(self.header).to_s
    end

    def handle_auto_params_create
        self.slug = make_slug(self.header).to_s
        self.published_time = pdate_today
    end
end

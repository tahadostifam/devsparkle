class Article < ApplicationRecord
    include Slug
    include PersianDate

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
    
    belongs_to :user
    has_many :comments
    has_many :likes

    validates_presence_of :header, :cover_text, :content
    validates_presence_of :image, on: :create
    
    def liked(uid)
        return self.likes.select { |l| l.user_id == uid && l.article_id == self.id }.length > 0
    end

    def like(aid, uid)
        l = Like.new(article_id: aid, user_id: uid)
        l.save!
    end

    def unlike(aid, uid)
        l = Like.find_by(article_id: aid, user_id: uid)
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

class Article < ApplicationRecord
    before_create :handle_auto_params_create
    before_update :handle_auto_params_update
    
    has_attached_file :image, {
        :storage => :ftp,
        :path => "/public_html/:attachment/:id/:style/:filename",
        :url => "http://zedxgroup.ir/:attachment/:id/:style/:filename",
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

    def to_slug(val)
        ret = val.strip
        ret.gsub! /['`]/,""
        ret.gsub! "#", "sharp"
        ret.gsub! " ", "-"
        ret.gsub! /\s*@\s*/, " at "
        ret.gsub! /\s*&\s*/, " and "
        ret.gsub! /_+/,"_"
        ret.gsub! /\A[_\.]+|[_\.]+\z/,""
        ret
    end

    def handle_auto_params_update
        self.slug = to_slug(self.header)
    end

    def handle_auto_params_create
        self.slug = to_slug(self.header)
        self.published_time = Date.today.to_pdate.strftime("%Y/%m/%d")
    end
end

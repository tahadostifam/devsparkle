class Article < ApplicationRecord
    before_create :handle_auto_params
    before_update :handle_auto_params
    
    has_one_attached :image

    belongs_to :user
    has_many :comments
    has_many :likes

    validates_presence_of :header, :cover_text, :content
    validates_presence_of :image, on: :create
    validates :image, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..3.megabytes }
    
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
        ret.gsub! /\s*@\s*/, " at "
        ret.gsub! /\s*&\s*/, " and "
        ret.gsub! /_+/,"_"
        ret.gsub! /\A[_\.]+|[_\.]+\z/,""
        ret
    end

    def handle_auto_params
        self.slug = to_slug(self.header)
    end
end

class Article < ApplicationRecord
    before_create :handle_auto_params

    has_one_attached :image

    belongs_to :user
    has_many :comments
    has_many :likes

    validates_presence_of :header, :cover_text, :content
    validates_presence_of :image, on: :create

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

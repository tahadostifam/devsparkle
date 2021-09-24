class Article < ApplicationRecord
    before_create :handle_auto_params

    has_one_attached :image

    belongs_to :user
    has_many :comments
    has_many :likes

    validates_presence_of :header, :cover_text, :content
    validates_presence_of :image, on: :create

    private

    def handle_auto_params
        self.slug = self.header
    end
end

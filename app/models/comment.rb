class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :article

    before_create :handle_auto_params

    private

    def handle_auto_params
        self.hash_id = SecureRandom.alphanumeric(30)
        self.send_time = Date.today.to_pdate.strftime("%Y/%m/%d")
    end
end

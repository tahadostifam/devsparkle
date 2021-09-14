class User < ApplicationRecord
    has_secure_password

    validates :password, confirmation: true
    validates_presence_of :full_name, :email, :username, :password_confirmation

    def email_activate
        self.email_confirmed = true
        self.confirm_token = nil
        save!(:validate => false)
    end

    before_create :confirmation_token

    private
    
    def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.base64(50).tr('+/=').to_s
      end
    end
end

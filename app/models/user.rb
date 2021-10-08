class User < ApplicationRecord
    has_many :articles
    
    has_secure_password

    attr_accessor :accept_terms_and_conditions

    validates :password, confirmation: true
    validates :username, uniqueness: true
    validates :email, uniqueness: true
    validates_presence_of :email, :username, :full_name
    validates_presence_of :password_confirmation, if: :password_digest_changed?
    validates_inclusion_of :gender, :in => ['عدم انتخاب', 'مذکر', 'مونث', nil]
    validates_acceptance_of :accept_terms_and_conditions, :message => "برای ثبت نام باید قوانین وبسایت را بپذیرید", :attribute => false
    
    def email_activate
        self.email_confirmed = true
        self.confirm_token = nil
        save!
    end

    before_create :confirmation_token

    private
    
    def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.hex(50)
      end
    end
end

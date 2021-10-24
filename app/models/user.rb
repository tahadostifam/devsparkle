require 'time'
require 'active_support/time'

class User < ApplicationRecord
    has_many :articles
    
    has_secure_password

    attr_accessor :accept_terms_and_conditions
    attr_accessor :remember_me

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

    def set_forgot_password_token
        self.forgot_password_token = SecureRandom.hex(50)
        self.forgot_password_expire_time = Time.now.to_s
        save!
    end

    def clean_forgot_password
        self.forgot_password_token = nil
        self.forgot_password_expire_time = nil
        save!
    end

    def forgot_password_valid_expire?
        uexpire = Time.parse(self.forgot_password_expire_time)
        valid = uexpire + 10.minute > Time.now
        unless valid?
            self.clean_forgot_password
        end
        return valid
    end

    before_create :confirmation_token

    private
    
    def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.hex(50)
      end
    end
end

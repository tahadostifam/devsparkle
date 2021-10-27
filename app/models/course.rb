class Course < ApplicationRecord
    has_many :course_episodes
    belongs_to :user
end

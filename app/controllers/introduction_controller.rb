class IntroductionController < ApplicationController
    def about_us
        @setting = Setting.first
    end
end

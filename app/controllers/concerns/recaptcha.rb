module Recaptcha
    def have_recaptcha(flash_name)
        gr_response = params["g-recaptcha-response"]
        if gr_response != nil && gr_response.strip != ""
          gr = Grecaptcha.new
          api_result = gr.verify_recaptcha(gr_response, request.remote_ip)
          if api_result == false
            flash[flash_name] = ["ریکپچا را تایید کنید."]
            return false
          else
            return true
          end
        else
          flash[flash_name] = ["ریکپچا را تایید کنید."]
          return false
        end
    end
end
require 'rest-client'
require 'json'

class Grecaptcha
    def verify_recaptcha(recaptcha_response, remote_ip)
        response = perform_verify_request(recaptcha_response, remote_ip)
        success?(response)
    end

    def success?(response)
        state = JSON.parse(response)["success"]
        if state == nil
            return false
        else
            return state  
        end
    end

    private

    attr_reader :client

    def perform_verify_request(recaptcha_response, remote_ip)
        api_url = "https://www.google.com/recaptcha/api/siteverify?secret=" + 
        ENV["RECAPTCHA_SECRETKEY"].to_s +
        "&response=" +
        recaptcha_response +
        "&remoteip=" +
        remote_ip;
        return RestClient.post api_url, {
            :accept => :json
        }
    end
end
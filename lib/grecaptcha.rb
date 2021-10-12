require 'rest-client'
require 'json'

class Grecaptcha
    API_URL = "https://www.google.com/recaptcha/api/siteverify".freeze

    def verify_recaptcha(recaptcha_response, remote_ip)
        response = perform_verify_request(recaptcha_response, remote_ip)
        success?(response)
    end

    def success?(response)
        JSON.parse(response)["success"]
    end

    private

    attr_reader :client

    def perform_verify_request(recaptcha_response, remote_ip)
        result = RestClient.post API_URL, {
            params: { 
                secret: ENV["RECAPTCHA_SECRETKEY"],
                response: recaptcha_response,
                remote_ip: remote_ip
            }, 
            accept: :json
        }
        puts "result: " + JSON.parse(result.to_json)["success"]
    end
end
require 'rest-client'
require 'json'

class GithubApi
    def clientid
        return ENV["GITHUB_CLIENT_ID"]
    end

    def fetch_github(callback_code)
        RestClient.post('https://github.com/login/oauth/access_token',
            {:client_id => ENV["GITHUB_CLIENT_ID"],
                :client_secret => ENV["GITHUB_SECRET_ID"],
                :code => callback_code},
                :accept => :json) { |at_res, at_req, at_resa| 
                    if at_res.code == 200 && JSON.parse(at_resa.body)['error'] != 'bad_verification_code'
                        access_token = JSON.parse(at_resa.body)['access_token']

                        auth_result = RestClient.get("https://api.github.com/user", 
                            {
                                Authorization: "token #{access_token}"
                            }
                        ) { |ar_res, ar_req, ar_resa|
                            puts ar_resa.body
                            if ar_res.code == 200
                                return JSON.parse(ar_resa.body)
                            else
                                return nil
                            end
                        }
                    else
                        return nil
                    end
                }
    end
end
require 'rest-client'
require 'json'

class GithubApi
    def clientid
        return ENV["GITHUB_CLIENT_ID"]
    end

    def fetch_github(callback_code)
        begin
            result = RestClient.post('https://github.com/login/oauth/access_token',
                {:client_id => ENV["GITHUB_CLIENT_ID"],
                    :client_secret => ENV["GITHUB_SECRET_ID"],
                    :code => callback_code},
                    :accept => :json)
    
        rescue RestClient::ExceptionWithResponse => err
            return nil
        end
    end
end

# if result.code == 200
#     access_token = JSON.parse(result)['access_token']

#     auth_result = RestClient.get("https://api.github.com/user", 
#         {
#             Authorization: "token #{access_token}"
#         }
#     )    
    
#     if auth_result.code == 200
#         final_result = JSON.parse(auth_result)

#         return final_result
#     else
#         return nil
#     end
# else
#     return nil
# end
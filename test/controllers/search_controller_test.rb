require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get q" do
    get search_q_url
    assert_response :success
  end
end

require "test_helper"

class IntroductionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get introduction_index_url
    assert_response :success
  end

  test "should get about_us" do
    get introduction_about_us_url
    assert_response :success
  end
end

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get signin" do
    get users_signin_url
    assert_response :success
  end

  test "should get signup" do
    get users_signup_url
    assert_response :success
  end

  test "should get forgot_password" do
    get users_forgot_password_url
    assert_response :success
  end

  test "should get terms_and_conditions" do
    get users_terms_and_conditions_url
    assert_response :success
  end
end

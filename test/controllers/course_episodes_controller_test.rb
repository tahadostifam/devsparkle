require "test_helper"

class CourseEpisodesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get course_episodes_index_url
    assert_response :success
  end

  test "should get show" do
    get course_episodes_show_url
    assert_response :success
  end
end

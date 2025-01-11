require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about_us" do
    get pages_about_us_url
    assert_response :success
  end

  test "should get working_with_us" do
    get pages_working_with_us_url
    assert_response :success
  end
end

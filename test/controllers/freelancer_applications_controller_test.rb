require "test_helper"

class FreelancerApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get freelancer_applications_new_url
    assert_response :success
  end

  test "should get create" do
    get freelancer_applications_create_url
    assert_response :success
  end

  test "should get index" do
    get freelancer_applications_index_url
    assert_response :success
  end

  test "should get show" do
    get freelancer_applications_show_url
    assert_response :success
  end

  test "should get edit" do
    get freelancer_applications_edit_url
    assert_response :success
  end

  test "should get update" do
    get freelancer_applications_update_url
    assert_response :success
  end

  test "should get destroy" do
    get freelancer_applications_destroy_url
    assert_response :success
  end
end

require "test_helper"

class CatchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get catches_index_url
    assert_response :success
  end

  test "should get show" do
    get catches_show_url
    assert_response :success
  end

  test "should get new" do
    get catches_new_url
    assert_response :success
  end

  test "should get create" do
    get catches_create_url
    assert_response :success
  end

  test "should get edit" do
    get catches_edit_url
    assert_response :success
  end

  test "should get update" do
    get catches_update_url
    assert_response :success
  end

  test "should get destroy" do
    get catches_destroy_url
    assert_response :success
  end
end

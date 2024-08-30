require "test_helper"

class CatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get catches_path
    assert_response :success
  end

  test "should get new" do
    get new_catch_path
    assert_response :success
  end

  test "should create catch" do
    post catches_path, params: { catch: { name: "Test Catch" } }
    assert_response :redirect
  end

  test "should show catch" do
    catch = catches(:one)
    get catch_path(catch)
    assert_response :success
  end

  test "should get edit" do
    catch = catches(:one)
    get edit_catch_path(catch)
    assert_response :success
  end

  test "should update catch" do
    catch = catches(:one)
    patch catch_path(catch), params: { catch: { name: "Updated Catch" } }
    assert_response :redirect
  end

  test "should destroy catch" do
    catch = catches(:one)
    delete catch_path(catch)
    assert_response :redirect
  end
end

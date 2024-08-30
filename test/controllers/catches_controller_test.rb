require "test_helper"

class CatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @catch = catches(:one)
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
    post catches_path, params: { catch: { tide: Catch.tides[:大潮], tide_level: Catch.tide_levels[:満潮前後], range: Catch.ranges[:トップ], size: Catch.sizes[:'20~30cm'], memo: "Test Memo", latitude: 35.6586, longitude: 139.7454 } }
    assert_response :redirect
  end

  test "should show catch" do
    get catch_path(@catch)
    assert_response :success
  end

  test "should get edit" do
    get edit_catch_path(@catch)
    assert_response :success
  end

  test "should update catch" do
    patch catch_path(@catch), params: { catch: { memo: "Updated Memo" } }
    assert_response :redirect
  end

  test "should destroy catch" do
    delete catch_path(@catch)
    assert_response :redirect
  end
end

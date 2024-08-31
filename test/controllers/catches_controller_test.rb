require "test_helper"
require "open-uri"

class CatchesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Deviseのテストヘルパーをインクルード

  def setup
    @user_one = users(:one)
    @catch_one = catches(:one)

    @user_two = users(:two)
    @catch_two = catches(:two)

    @user_three = users(:three)
    @catch_three = catches(:three)
  end

  # ユーザー one のテストケース
  test "should get index for user one" do
    sign_in @user_one
    get catches_path
    assert_response :success
  end

  test "should get new for user one" do
    sign_in @user_one
    get new_catch_path
    assert_response :success
  end

  test "should create catch for user one" do
    sign_in @user_one
    post catches_path, params: { catch: { tide: Catch.tides[:大潮], tide_level: Catch.tide_levels[:"満潮前後"], range: Catch.ranges[:トップ], size: Catch.sizes[:"20〜30cm"], memo: "Test Memo", latitude: 35.6586, longitude: 139.7454 } }
    assert_response :redirect
  end

  test "should show catch for user one" do
    sign_in @user_one
    get catch_path(@catch_one)
    assert_response :success
  end

  test "should get edit for user one" do
    sign_in @user_one
    get edit_catch_path(@catch_one)
    assert_response :success
  end

  test "should update catch for user one" do
    sign_in @user_one
    patch catch_path(@catch_one), params: { catch: { memo: "Updated Memo" } }
    assert_response :redirect
  end

  test "should destroy catch for user one" do
    sign_in @user_one
    delete catch_path(@catch_one)
    assert_response :redirect
  end

  # ユーザー two のテストケース
  test "should get index for user two" do
    sign_in @user_two
    get catches_path
    assert_response :success
  end

  test "should get new for user two" do
    sign_in @user_two
    get new_catch_path
    assert_response :success
  end

  test "should create catch for user two" do
    sign_in @user_two
    post catches_path, params: { catch: { tide: Catch.tides[:中潮], tide_level: Catch.tide_levels[:"上げ3〜4部"], range: Catch.ranges[:中層], size: Catch.sizes[:"30〜40cm"], memo: "Another Test Memo", latitude: 34.0522, longitude: -118.2437 } }
    assert_response :redirect
  end

  test "should show catch for user two" do
    sign_in @user_two
    get catch_path(@catch_two)
    assert_response :success
  end

  test "should get edit for user two" do
    sign_in @user_two
    get edit_catch_path(@catch_two)
    assert_response :success
  end

  test "should update catch for user two" do
    sign_in @user_two
    patch catch_path(@catch_two), params: { catch: { memo: "Another Updated Memo" } }
    assert_response :redirect
  end

  test "should destroy catch for user two" do
    sign_in @user_two
    delete catch_path(@catch_two)
    assert_response :redirect
  end

  # ユーザー three のテストケース
  test "should get index for user three" do
    sign_in @user_three
    get catches_path
    assert_response :success
  end

  test "should get new for user three" do
    sign_in @user_three
    get new_catch_path
    assert_response :success
  end

  test "should create catch for user three" do
    sign_in @user_three
    post catches_path, params: { catch: { tide: Catch.tides[:小潮], tide_level: Catch.tide_levels[:"下げ7〜8部"], range: Catch.ranges[:ボトム付近], size: Catch.sizes[:"40〜50cm"], memo: "Third Test Memo", latitude: 51.5074, longitude: -0.1278 } }
    assert_response :redirect
  end

  test "should show catch for user three" do
    sign_in @user_three
    get catch_path(@catch_three)
    assert_response :success
  end

  test "should get edit for user three" do
    sign_in @user_three
    get edit_catch_path(@catch_three)
    assert_response :success
  end

  test "should update catch for user three" do
    sign_in @user_three
    patch catch_path(@catch_three), params: { catch: { memo: "Third Updated Memo" } }
    assert_response :redirect
  end

  test "should destroy catch for user three" do
    sign_in @user_three
    delete catch_path(@catch_three)
    assert_response :redirect
  end
end

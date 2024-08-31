require "test_helper"
require "open-uri"

class DiariesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Deviseのテストヘルパーをインクルード

  def setup
    @user_one = users(:one)
    @diary_one = diaries(:one)

    @user_two = users(:two)
    @diary_two = diaries(:two)

    @user_three = users(:three)
    @diary_three = diaries(:three)
  end

  test "should get index for user one" do
    sign_in @user_one
    get diaries_path
    assert_response :success
  end

  test "should get new for user one" do
    sign_in @user_one
    get new_diary_path
    assert_response :success
  end

  test "should create diary for user one" do
    sign_in @user_one
    post diaries_path, params: { diary: { diary_date: Date.today, weather: 0, catch_count: 1, time_of_day: 0, temperature: 0, content: "Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user one" do
    sign_in @user_one
    get diary_path(@diary_one)
    assert_response :success
  end

  test "should get edit for user one" do
    sign_in @user_one
    get edit_diary_path(@diary_one)
    assert_response :success
  end

  test "should update diary for user one" do
    sign_in @user_one
    patch diary_path(@diary_one), params: { diary: { content: "Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary for user one" do
    sign_in @user_one
    delete diary_path(@diary_one)
    assert_response :redirect
  end

  # ユーザー two のテストケース
  test "should get index for user two" do
    sign_in @user_two
    get diaries_path
    assert_response :success
  end

  test "should get new for user two" do
    sign_in @user_two
    get new_diary_path
    assert_response :success
  end

  test "should create diary for user two" do
    sign_in @user_two
    post diaries_path, params: { diary: { diary_date: Date.today, weather: 1, catch_count: 2, time_of_day: 1, temperature: 1, content: "Another Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user two" do
    sign_in @user_two
    get diary_path(@diary_two)
    assert_response :success
  end

  test "should get edit for user two" do
    sign_in @user_two
    get edit_diary_path(@diary_two)
    assert_response :success
  end

  test "should update diary for user two" do
    sign_in @user_two
    patch diary_path(@diary_two), params: { diary: { content: "Another Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary for user two" do
    sign_in @user_two
    delete diary_path(@diary_two)
    assert_response :redirect
  end

  # ユーザー three のテストケース
  test "should get index for user three" do
    sign_in @user_three
    get diaries_path
    assert_response :success
  end

  test "should get new for user three" do
    sign_in @user_three
    get new_diary_path
    assert_response :success
  end

  test "should create diary for user three" do
    sign_in @user_three
    post diaries_path, params: { diary: { diary_date: Date.today, weather: 2, catch_count: 3, time_of_day: 2, temperature: 2, content: "Third Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user three" do
    sign_in @user_three
    get diary_path(@diary_three)
    assert_response :success
  end

  test "should get edit for user three" do
    sign_in @user_three
    get edit_diary_path(@diary_three)
    assert_response :success
  end

  test "should update diary for user three" do
    sign_in @user_three
    patch diary_path(@diary_three), params: { diary: { content: "Third Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary for user three" do
    sign_in @user_three
    delete diary_path(@diary_three)
    assert_response :redirect
  end
end

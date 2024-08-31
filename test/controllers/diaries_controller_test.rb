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

    [@user_one, @user_two, @user_three].each do |user|
      unless user.profile_image.attached?
        user.profile_image.attach(io: File.open(Rails.root.join("public/default_profile_image.png")), filename: "default_profile_image.png", content_type: "image/png")
      end
    end
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
    post diaries_path, params: { diary: { diary_date: Date.today, weather: "晴れ", catch_count: "1匹", time_of_day: "朝まづめ", temperature: "10~20℃", content: "Test Content" } }
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
    post diaries_path, params: { diary: { diary_date: Date.today, weather: "曇り", catch_count: "2匹", time_of_day: "夕まづめ", temperature: "10~20℃", content: "Another Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user two" do
    sign_in @user_two
   
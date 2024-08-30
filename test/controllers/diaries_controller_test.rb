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

    [ @user_one, @user_two, @user_three ].each do |user|
      unless user.profile_image.attached?
        user.profile_image.attach(io: File.open(Rails.root.join("public/default_profile_image.png")), filename: "default_profile_image.png", content_type: "image/png")
      end
    end
  end

  test "should get index for user one" do
    sign_in @user_one
    assert user_signed_in?, "User one should be signed in"
    get diaries_path
    assert_response :success
  end

  test "should get new for user one" do
    sign_in @user_one
    assert user_signed_in?, "User one should be signed in"
    get new_diary_path
    assert_response :success
  end

  test "should create diary for user one" do
    sign_in @user_one
    assert user_signed_in?, "User one should be signed in"
    post diaries_path, params: { diary: { diary_date: Date.today, weather: "晴れ", catch_count: "1匹", time_of_day: "朝まづめ", temperature: "10~20℃", content: "Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user one" do
    sign_in @user_one
    assert user_signed_in?, "User one should be signed in"
    get diary_path(@diary_one)
    assert_response :success
  end

  test "should get edit for user one" do
    sign_in @user_one
    assert user_signed_in?, "User one should be signed in"
    get edit_diary_path(@diary_one)
    assert_response :success
  end

  test "should update diary for user one" do
    sign_in @user_one
    assert user_signed_in?, "User one should be signed in"
    patch diary_path(@diary_one), params: { diary: { content: "Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary for user one" do
    sign_in @user_one
    assert user_signed_in?, "User one should be signed in"
    delete diary_path(@diary_one)
    assert_response :redirect
  end

  # ユーザー two のテストケース
  test "should get index for user two" do
    sign_in @user_two
    assert user_signed_in?, "User two should be signed in"
    get diaries_path
    assert_response :success
  end

  test "should get new for user two" do
    sign_in @user_two
    assert user_signed_in?, "User two should be signed in"
    get new_diary_path
    assert_response :success
  end

  test "should create diary for user two" do
    sign_in @user_two
    assert user_signed_in?, "User two should be signed in"
    post diaries_path, params: { diary: { diary_date: Date.today, weather: "曇り", catch_count: "2匹", time_of_day: "夕まづめ", temperature: "10~20℃", content: "Another Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user two" do
    sign_in @user_two
    assert user_signed_in?, "User two should be signed in"
    get diary_path(@diary_two)
    assert_response :success
  end

  test "should get edit for user two" do
    sign_in @user_two
    assert user_signed_in?, "User two should be signed in"
    get edit_diary_path(@diary_two)
    assert_response :success
  end

  test "should update diary for user two" do
    sign_in @user_two
    assert user_signed_in?, "User two should be signed in"
    patch diary_path(@diary_two), params: { diary: { content: "Another Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary for user two" do
    sign_in @user_two
    assert user_signed_in?, "User two should be signed in"
    delete diary_path(@diary_two)
    assert_response :redirect
  end

  # ユーザー three のテストケース
  test "should get index for user three" do
    sign_in @user_three
    assert user_signed_in?, "User three should be signed in"
    get diaries_path
    assert_response :success
  end

  test "should get new for user three" do
    sign_in @user_three
    assert user_signed_in?, "User three should be signed in"
    get new_diary_path
    assert_response :success
  end

  test "should create diary for user three" do
    sign_in @user_three
    assert user_signed_in?, "User three should be signed in"
    post diaries_path, params: { diary: { diary_date: Date.today, weather: "雨", catch_count: "3匹", time_of_day: "デイゲーム", temperature: "20~30℃", content: "Third Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user three" do
    sign_in @user_three
    assert user_signed_in?, "User three should be signed in"
    get diary_path(@diary_three)
    assert_response :success
  end

  test "should get edit for user three" do
    sign_in @user_three
    assert user_signed_in?, "User three should be signed in"
    get edit_diary_path(@diary_three)
    assert_response :success
  end

  test "should update diary for user three" do
    sign_in @user_three
    assert user_signed_in?, "User three should be signed in"
    patch diary_path(@diary_three), params: { diary: { content: "Third Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary for user three" do
    sign_in @user_three
    assert user_signed_in?, "User three should be signed in"
    delete diary_path(@diary_three)
    assert_response :redirect
  end
end

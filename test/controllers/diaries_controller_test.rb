require "test_helper"

class DiariesControllerTest < ActionDispatch::IntegrationTest
  # ユーザー one のテストケース
  setup do
    @user_one = users(:one)
    sign_in @user_one
    @diary_one = diaries(:one)
  end

  test "should get index for user one" do
    get diaries_path
    assert_response :success
  end

  test "should get new for user one" do
    get new_diary_path
    assert_response :success
  end

  test "should create diary for user one" do
    post diaries_path, params: { diary: { diary_date: Date.today, weather: Diary.weathers[:晴れ], catch_count: Diary.catch_counts[:'1匹'], time_of_day: Diary.time_of_days[:朝まづめ], temperature: Diary.temperatures[:'10~20℃'], content: "Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user one" do
    get diary_path(@diary_one)
    assert_response :success
  end

  test "should get edit for user one" do
    get edit_diary_path(@diary_one)
    assert_response :success
  end

  test "should update diary for user one" do
    patch diary_path(@diary_one), params: { diary: { content: "Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary for user one" do
    delete diary_path(@diary_one)
    assert_response :redirect
  end

  # ユーザー two のテストケース
  setup do
    @user_two = users(:two)
    sign_in @user_two
    @diary_two = diaries(:two)
  end

  test "should get index for user two" do
    get diaries_path
    assert_response :success
  end

  test "should get new for user two" do
    get new_diary_path
    assert_response :success
  end

  test "should create diary for user two" do
    post diaries_path, params: { diary: { diary_date: Date.today, weather: Diary.weathers[:曇り], catch_count: Diary.catch_counts[:'2匹'], time_of_day: Diary.time_of_days[:夕まづめ], temperature: Diary.temperatures[:'10~20℃'], content: "Another Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user two" do
    get diary_path(@diary_two)
    assert_response :success
  end

  test "should get edit for user two" do
    get edit_diary_path(@diary_two)
    assert_response :success
  end

  test "should update diary for user two" do
    patch diary_path(@diary_two), params: { diary: { content: "Another Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary for user two" do
    delete diary_path(@diary_two)
    assert_response :redirect
  end

  # ユーザー three のテストケース
  setup do
    @user_three = users(:three)
    sign_in @user_three
    @diary_three = diaries(:three)
  end

  test "should get index for user three" do
    get diaries_path
    assert_response :success
  end

  test "should get new for user three" do
    get new_diary_path
    assert_response :success
  end

  test "should create diary for user three" do
    post diaries_path, params: { diary: { diary_date: Date.today, weather: Diary.weathers[:雨], catch_count: Diary.catch_counts[:'3匹'], time_of_day: Diary.time_of_days[:デイゲーム], temperature: Diary.temperatures[:'20~30℃'], content: "Third Test Content" } }
    assert_response :redirect
  end

  test "should show diary for user three" do
    get diary_path(@diary_three)
    assert_response :success
  end

  test "should get edit for user three" do
    get edit_diary_path(@diary_three)
    assert_response :success
  end

  test "should update diary for user three" do
    patch diary_path(@diary_three), params: { diary: { content: "Third Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary for user three" do
    delete diary_path(@diary_three)
    assert_response :redirect
  end
end

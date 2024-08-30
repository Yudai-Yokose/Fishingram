require "test_helper"

class DiariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @diary = diaries(:one)
  end

  test "should get index" do
    get diaries_path
    assert_response :success
  end

  test "should get new" do
    get new_diary_path
    assert_response :success
  end

  test "should create diary" do
    post diaries_path, params: { diary: { diary_date: Date.today, weather: Diary.weathers[:晴れ], catch_count: Diary.catch_counts[:'1匹'], time_of_day: Diary.time_of_days[:朝まづめ], temperature: Diary.temperatures[:'10~20℃'], content: "Test Content" } }
    assert_response :redirect
  end

  test "should show diary" do
    get diary_path(@diary)
    assert_response :success
  end

  test "should get edit" do
    get edit_diary_path(@diary)
    assert_response :success
  end

  test "should update diary" do
    patch diary_path(@diary), params: { diary: { content: "Updated Content" } }
    assert_response :redirect
  end

  test "should destroy diary" do
    delete diary_path(@diary)
    assert_response :redirect
  end
end

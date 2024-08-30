require "test_helper"
require "open-uri"

class HomeControllerTest < ActionDispatch::IntegrationTest
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

  test "should get index" do
    get root_url
    assert_response :success
  end
end

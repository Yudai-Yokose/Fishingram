require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      username: "testuser",
      email: "user_#{SecureRandom.hex(10)}@example.com",
      password: "password"
    )
    unless @user.profile_image.attached?
      @user.profile_image.attach(io: File.open(Rails.root.join("public/default_profile_image.png")), filename: "default_profile_image.png", content_type: "image/png")
    end
    sign_in @user
  end
  
  setup do
    User.destroy_all  # ここで delete_all ではなく destroy_all を使用する
    @user = User.create!(
      username: "testuser",
      email: "user_#{SecureRandom.hex(10)}@example.com",
      password: "password"
    )
  end

  test "should get index" do
    get root_url
    assert_response :success
  end
end

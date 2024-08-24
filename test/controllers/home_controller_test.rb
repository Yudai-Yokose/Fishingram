require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    User.delete_all
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

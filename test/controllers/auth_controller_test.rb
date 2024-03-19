require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get register" do
    get auth_register_url
    assert_response :success
  end
end

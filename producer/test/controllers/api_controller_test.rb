require "test_helper"

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get v1" do
    get api_v1_url
    assert_response :success
  end
end

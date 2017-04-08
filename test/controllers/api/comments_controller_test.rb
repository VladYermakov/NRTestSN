require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get angular" do
    get comments_angular_url
    assert_response :success
  end

end

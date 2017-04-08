require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get angular" do
    get articles_angular_url
    assert_response :success
  end

end

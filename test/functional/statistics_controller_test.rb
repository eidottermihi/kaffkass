require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  test "should get consume_chart" do
    get :consume_chart
    assert_response :success
  end

end

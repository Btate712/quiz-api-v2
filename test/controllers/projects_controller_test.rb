require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {
      "Content-type": "application/json"
    }
  end

  test "get /projects request is successful" do
    get projects_url
    assert_response :success
  end
end

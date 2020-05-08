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

  test "get /projects request response includes an array of projects" do 
    get projects_url 
    assert !!JSON.parse(@response.body)["projects"]
  end

  test "get /projects request response includes project names" do 
    get projects_url 
    assert !!JSON.parse(@response.body)["projects"].first.has_key?("name")
  end

  test "get /projects request response includes project is_public fields" do 
    get projects_url 
    assert !!JSON.parse(@response.body)["projects"].first.has_key?("is_public")
  end
end

require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {
      "Content-type": "application/json"
    }
  end

  test "get /projects request is successful" do
    get projects_url, headers: @headers
    assert_response :success
  end

  test "get /projects request response includes an array of projects" do 
    get projects_url, headers: @headers 
    assert !!JSON.parse(@response.body)["projects"]
  end

  test "get /projects request response includes project names" do 
    get projects_url, headers: @headers 
    assert !!JSON.parse(@response.body)["projects"].first.has_key?("name")
  end

  test "get /projects request response includes project is_public fields" do 
    get projects_url, headers: @headers 
    assert !!JSON.parse(@response.body)["projects"].first.has_key?("is_public")
  end

  test "get /projects[:id] request is successful" do 
    get project_url(1), headers: @headers
    assert_response :success
  end

  test "get /projcects[:id] request response includes the project name" do 
    get project_url(1), headers: @headers 
    assert JSON.parse(@response.body)["project"].has_key?("name")
  end

  test "get /projcects[:id] request response includes the project is_public flag" do 
    get project_url(1), headers: @headers 
    assert JSON.parse(@response.body)["project"].has_key?("is_public")
  end
end

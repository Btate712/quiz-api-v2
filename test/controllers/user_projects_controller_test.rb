require 'test_helper'

class UserProjectsControllerTest < ActionDispatch::IntegrationTest
  # index
  test "get /user_projects/ lists all user_projects when requested by a user with access to the project" do 
    get user_projects_url, headers: @headers 
    assert @response.body.include?("projects")
  end

  # TODO: ensure user without access cannot change user_projects

  # show
  test "get /user_projects/[:id] response includes the user name, user id, access level, project name, and project id" do
    get user_project_url(1), headers: @headers 
    required_fields_found = true 
    response = @response.body
    if (!response.include?("user_name") ||
      !response.include?("user_id") ||
      !response.include?("access_level") ||
      !response.include?("project_name") ||
      !response.include?("project_id")
    )
      required_fields_found = false
    end 
    assert required_fields_found
  end

  # create
  test "post /user_projects/ creates a new user_project" do 
    user_project_count_before_create = UserProject.count 
    post user_projects_url(user_id: 1, project_id: 1, access_level: READ_LEVEL), headers: @headers
    assert UserProject.count == user_project_count_before_create + 1
  end

  # update
  test "can change a user's access level using put /user_projects/[:id]" do
    put user_project_url(1, access_level: WRITE_LEVEL)
    assert UserProject.find(1).access_level == WRITE_LEVEL
  end

  # TODO: ensure user cannot change access level without appropriate project rights 
  
  # delete
end

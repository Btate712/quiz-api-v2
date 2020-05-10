require 'test_helper'

class UserProjectsControllerTest < ActionDispatch::IntegrationTest
  # index
  test "lists all user_projects when requested by a user with access to the project" do 
    get user_projects_url, headers: @headers 
    assert @response.body.include?("projects")
  end

  # TODO: ensure user without access cannot change user_projects

  # show
  test "/user_projects/[:id] response includes the user name, user id, access level, project name, and project id" do
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

  # update

  # delete
end

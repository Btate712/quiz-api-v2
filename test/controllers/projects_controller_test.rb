require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {
      "Content-type": "application/json"
    }
  end

  # index
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

  # show
  test "get /projects/[:id] request is successful" do 
    get project_url(1), headers: @headers
    assert_response :success
  end

  test "get /projcects/[:id] request response includes the project name" do 
    get project_url(1), headers: @headers 
    assert JSON.parse(@response.body)["project"].has_key?("name")
  end

  test "get /projcects/[:id] request response includes the project is_public flag" do 
    get project_url(1), headers: @headers 
    assert JSON.parse(@response.body)["project"].has_key?("is_public")
  end

  # TODO: write test to verify user can't see projects they don't have access to

  # create
  test "post /projects request creates a new project" do
    project_count = Project.count
    post projects_url(name: "New Project", is_public: false), headers: @headers 
    assert Project.count == project_count + 1
  end

  test "post /projects request creates a new user_project with write access" do 
    name = "Another Project"
    post projects_url(name: name, is_public: false), headers: @headers
    assert UserProject.last.project.name == name && UserProject.last.access_level == WRITE_LEVEL
  end

  #update
  test "put /projects/[:id] request is successful" do 
    put project_url(id: 1, name: "A new name"), headers: @headers 
    assert_response :success
  end

  test "put /projects/[:id] can change the name of a project the user has write access to" do 
    name = "Another new name"
    put project_url(id: 1, name: name), headers: @headers 
    assert Project.find(1).name == name
  end 

  # TODO - Add test to verify user can't change project without access
  
  #delete
  test "delete /projects/[:id] request is successful" do 
    project_count_before_delete = Project.count
    delete project_url(2), headers: @headers 
    assert Project.count == project_count_before_delete - 1
  end

  test "delete /projects/[:id] request removes all records that reference the deleted project" do 
    project_id_to_delete = 1
    delete project_url(project_id_to_delete), headers: @headers 

    cleaned_up = true
    if Topic.find_by(project_id: project_id_to_delete) || UserProject.find_by(project_id: project_id_to_delete) 
      cleaned_up = false
    end
    
    assert cleaned_up
  end
end

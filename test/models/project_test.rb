require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "saves a project with a name" do
    project = Project.new(name: "My Project")
    assert project.save, "Project failed to save"
  end
  
  test "does not save a project without a name" do
    project = Project.new()
    assert_not project.save, "Project saved without a name"
  end

  test "does not save a project with the same name as an existing project" do
    project = Project.new(name: projects(:one).name);
    assert_not project.save, "Project saved with same name as existing project"
  end

  # kill method
  test "kill method removes all topics and user_projects that reference the deleted project" do 
    project = Project.first 
    project_id = project.id 
    project.kill

    cleaned_up = true 
    if UserProject.all.find_by(project_id: project_id) || Topic.all.find_by(project_id: project_id)
      cleaned_up = false 
    end
    assert cleaned_up
  end 
end

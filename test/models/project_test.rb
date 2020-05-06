require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "saves a project with a name" do
    project = Project.new(name: "My Project")
    assert project.save
  end
  
  test "does not save a project without a name" do
    project = Project.new()
    assert_not project.save
  end
end

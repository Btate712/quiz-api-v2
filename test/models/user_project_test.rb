require 'test_helper'

class UserProjectTest < ActiveSupport::TestCase
  test "should save if a user_id, project_id, and access_level is provided" do
    user_project = UserProject.new(user_id: User.first.id, project_id: Project.first.id, access_level: 30)
    assert user_project.save
  end
  
  test "should not save if a user_id is not provided" do 
    user_project = UserProject.new(project_id: Project.first.id, access_level: 30)
    assert_not user_project.save
  end

  test "should not save if a project_id is not provided" do 
    user_project = UserProject.new(user_id: User.first.id, access_level: 30)
    assert_not user_project.save
  end
  
  test "should not save if an access_level is not provided" do 
    user_project = UserProject.new(user_id: User.first.id, project_id: Project.first.id)
    assert_not user_project.save
  end

  test "should not save the same project twice for a user" do
    user_project = UserProject.create(user_id: User.first.id, project_id: Project.first.id, access_level: 30)
    user_project_2 = UserProject.new(user_id: User.first.id, project_id: Project.first.id, access_level: 30)
    assert_not user_project_2.save
  end
  
  test "should save the same project twice for different users" do
    user = User.new(name: "bob", email: "bob@bob.bob", password: "temp")
    user.save
    user_project = UserProject.create(user_id: User.first.id, project_id: Project.first.id, access_level: 30)
    user_project_2 = UserProject.new(user_id: user.id, project_id: Project.first.id, access_level: 30)
    assert user_project_2.save
  end

end

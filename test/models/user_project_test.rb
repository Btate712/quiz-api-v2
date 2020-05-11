require 'test_helper'

class UserProjectTest < ActiveSupport::TestCase
  test "should save if a user_id, project_id, and access_level is provided" do
    user_project = UserProject.new(user_id: users(:one).id, project_id: projects(:one).id, access_level: 30)
    assert user_project.save
  end
  
  test "should not save if a user_id is not provided" do 
    user_project = UserProject.new(project_id: projects(:one).id, access_level: 30)
    assert_not user_project.save
  end

  test "should not save if a project_id is not provided" do 
    user_project = UserProject.new(user_id: users(:one).id, access_level: 30)
    assert_not user_project.save
  end
  
  test "should not save if an access_level is not provided" do 
    user_project = UserProject.new(user_id: users(:one).id, project_id: projects(:one).id)
    assert_not user_project.save
  end

  test "should not save the same project twice for a user" do
    user_project = UserProject.create(user_id: users(:one).id, project_id: projects(:one).id, access_level: 30)
    user_project_2 = UserProject.new(user_id: users(:one).id, project_id: projects(:one).id, access_level: 30)
    assert_not user_project_2.save
  end
  
  test "should save the same project twice for different users" do
    user_project = UserProject.create(user_id: users(:one).id, project_id: projects(:one).id, access_level: 30)
    user_project_2 = UserProject.new(user_id: users(:two).id, project_id: projects(:one).id, access_level: 30)
    assert user_project_2.save
  end

  # kill method 
  test "kill method should delete the user_project" do 
    user_project_count_before_delete = UserProject.count 
    UserProject.first.kill 
    assert UserProject.count == user_project_count_before_delete - 1
  end
end

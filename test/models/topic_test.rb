require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test "should save a topic with a name and project_id" do
    project = Project.create(name: "My Project")
    topic = Topic.new(name: "something", project_id: project.id)
    assert topic.save
  end

  test "should not save a topic without a name" do 
    project = Project.create(name: "My Project")
    topic = Topic.new(project_id: project.id)
    assert_not topic.save
  end

  test "should not save a topic without a project_id" do 
    topic = Topic.new(name: "My Project")
    assert_not topic.save
  end
end

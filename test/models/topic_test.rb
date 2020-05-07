require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test "should save a topic with a name and project_id" do
    topic = Topic.new(name: "something", project_id: projects(:one).id)
    assert topic.save
  end

  test "should not save a topic without a name" do 
    topic = Topic.new(project_id: projects(:one).id)
    assert_not topic.save
  end

  test "should not save a topic without a project_id" do 
    topic = Topic.new(name: "My Project")
    assert_not topic.save
  end

  test "should not save a topic with the same name as another topic within the same project" do
    topic = Topic.create(name: "My Topic", project_id: projects(:one).id)
    otherTopic = Topic.new(name: topic.name, project_id: projects(:one).id)
    assert_not otherTopic.save
  end

  test "should save a topic with the same name as another topic in a different project" do
    topic = Topic.create(name: "My Topic", project_id: projects(:one).id)
    otherTopic = Topic.new(name: topic.name, project_id: projects(:two).id)
    assert otherTopic.save
  end
end

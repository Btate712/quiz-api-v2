require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  # index
  test "get /topics response includes a list of topics" do
    get topics_url, headers: @headers
    assert @response.body.include?("topics")
  end

  # TODO: ensure that only topics that the user has access to are shown

  # show
  test "get /topics/[:id] response includes a topic along with its questions" do 
    get topic_url(1), headers: @headers
    assert @response.body.include?("questions")
  end

  # create
  test "post /topics creates a new topic" do
    topic_count_before_create = Topic.count
    post topics_url(name: "some new topic", project_id: 1), headers: @headers
    assert Topic.count == topic_count_before_create + 1
  end

  # update
  test "topic can be updated via an update request to /topics/[:id]" do
    new_name = "Some other topic name"
    put topic_url(1, name: new_name), headers: @headers 
    assert Topic.find(1).name == new_name
  end

  # delete
  test "delete /topics/[:id] deletes a topic" do 
    topic_count_before_delete = Topic.count
    delete topic_url(1), headers: @headers
    assert Topic.count == topic_count_before_delete - 1
  end
end

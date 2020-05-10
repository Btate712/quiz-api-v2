require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  # index
  test "/topics response includes a list of topics" do
    get topics_url
    @response.include?("topics")
  end

  # TODO: ensure that only topics that the user has access to are shown
  
  # show

  # create

  # update

  # delete
end

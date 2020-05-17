require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  # index
  test "get /questions response includes questions" do
    get questions_url, headers: @headers
    assert @response.body.include?("questions")
  end

  # show

  # create 

  # update 

  # destroy 

end
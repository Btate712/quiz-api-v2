require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {
      "Content-type": "application/json"
    }
  end

  test "get /users request is successful" do
    get users_url
    assert_response :success
  end

  test "get /users request returns text that includes the word 'users'" do
    get users_url
    assert @response.body.include?("users")
  end

  test "get /users request returns JSON that includes an array of all users" do
    get users_url
    users = JSON.parse(@response.body)["users"]
    assert users.count === User.all.count
  end
end

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

  test "get /users request response includes user names" do
    get users_url
    user = JSON.parse(@response.body)["users"].first
    assert user.has_key?("name")
  end

  test "get /users request response includes user is_admin field" do
    get users_url
    user = JSON.parse(@response.body)["users"].first
    assert user.has_key?("is_admin")
  end

  test "get /users request response does not include password-digests" do
    get users_url
    user = JSON.parse(@response.body)["users"].first
    assert_not user.has_key?("password_digest")
  end

  test "post /users request creates a new user when supplied with the appropriate data" do
    beforeUserCount = User.all.count
    post users_url(name: "NewUser01", password: "password", email: "someEmail@gmail.com")
    assert User.all.count == beforeUserCount + 1 
  end
end

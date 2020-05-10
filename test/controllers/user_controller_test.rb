require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "get /users request is successful" do
    get users_url, headers: @headers
    assert_response :success
  end

  test "get /users request returns text that includes the word 'users'" do
    get users_url, headers: @headers
    assert @response.body.include?("users")
  end

  test "get /users request returns JSON that includes an array of all users" do
    get users_url, headers: @headers
    users = JSON.parse(@response.body)["users"]
    assert users.count === User.all.count
  end

  test "get /users request response includes user names" do
    get users_url, headers: @headers
    user = JSON.parse(@response.body)["users"].first
    assert user.has_key?("name")
  end
  
    test "get /users  request response includes user ids" do
      get users_url, headers: @headers
      user = JSON.parse(@response.body)["users"].first
      assert user.has_key?("id")
    end

  test "get /users request response does not include password_digests" do
    get users_url, headers: @headers
    user = JSON.parse(@response.body)["users"].first
    assert_not user.has_key?("password_digest")
  end

  test "post /users request creates a new user when supplied with the appropriate data" do
    beforeUserCount = User.all.count
    post users_url(name: "NewUser01", password: "password", email: "someEmail@gmail.com"), headers: @headers
    assert User.all.count == beforeUserCount + 1 
  end

  test "post /users request creates a new user correctly supplied with the appropriate data" do
    post users_url(name: "NewUser02", password: "password", email: "someEmail2@gmail.com"), headers: @headers
    assert User.last.name = "NewUser02" && User.last.email = "someEmail2@gmail.com"
  end
  
  test "post /users does not respond with an error message if user is successfully saved" do
    post users_url(name: "NewUser03", password: "password", email: "someEmail3@gmail.com"), headers: @headers
    assert_not !!JSON.parse(@response.body)['errors']
  end
  
  test "post /users responds with an error message if user with same name already exists" do
    post users_url(name: "Bob", password: "password", email: "someEmail2@gmail.com"), headers: @headers
    assert !!JSON.parse(@response.body)['errors']
  end

  test "get /users/[:id] request is successful" do 
    get user_url(1), headers: @headers 
    assert_response :success
  end

  test "get /users/[:id] request returns a user object" do 
    get user_url(1), headers: @headers 
    assert !!JSON.parse(@response.body)["user"]
  end

  test "get /users/[:id] request response does not include password_digest" do 
    get user_url(1), headers: @headers
    assert_not JSON.parse(@response.body)["user"].has_key?("password_digest")
  end

  test "put /users/[:id] request is successful" do
    put user_url(id: 1, name: "Modified"), headers: @headers
    assert_response :success
  end

  test "put /users/[:id] request modifies an existing user" do 
    put user_url(id: 1, name: "Modified Again"), headers: @headers 
    assert User.find(1).name == "Modified Again"
  end

  test "delete /users/[:id] deletes an existing user" do 
    user_Count = User.count
    delete user_url(User.last.id), headers: @headers
    assert User.count == user_Count - 1
  end

  test "delete /users/[:id] deletes comments associated with the deleted user" do 
    comment_count = Comment.count
    delete user_url(User.find_by(id: 5).id), headers: @headers
    assert Comment.count == comment_count - 1
  end
end

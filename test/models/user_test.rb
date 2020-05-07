require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should save a user with a name, email, and password" do
    user = User.new(name: "bob", email: "bob@bob.bob", password: "temp")
    assert user.save
  end
    
  test "should not save a user without a name" do
    user = User.new(email: "bob@bob.bob", password: "temp")
    assert_not user.save
  end

  test "should not save a user without an email" do
    user = User.new(name: "bob", password: "temp")
    assert_not user.save
  end

  test "should not save a user with a name of a user that already exists" do
    user = User.new(name: users(:one).name, email: "someEmail@email.email", password: "password")
    assert_not user.save
  end
  
  test "should not save a user with the same email as a user that already exists" do
    user = User.new(name: "OtherBob", email: users(:one).email, password: "password")
    assert_not user.save
  end

  test "should have read access to a topic if access_level is >= 10" do
    assert users(:one).has_project_rights?(projects(:one), READ_LEVEL)  
  end

  test "should not have read access to a topic if no user_topic connection exists" do
    assert_not users(:three).has_project_rights?(projects(:one), READ_LEVEL)  
  end

  test "should have write access to a topic if access_level is >= 20" do 
    assert users(:two).has_project_rights?(projects(:one), WRITE_LEVEL)
  end

  test "should not have write access to a topic if access_level is < 20" do
    assert_not users(:one).has_project_rights?(projects(:one), READ_LEVEL)
  end
end

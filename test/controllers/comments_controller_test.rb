require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest  
    # show
    test "get /comments/[:id] response includes the comment" do 
      get comment_url(1), headers: @headers
      assert @response.body.include?("comment")
    end
  
    # create
    test "post /comments creates a new comment" do
      comment_count_before_create = Comment.count
      post comments_url(
        content: "some new comment", 
        question_id: 1,
        user_id: 1,
        comment_type: "test",
      ), headers: @headers
      assert Comment.count == comment_count_before_create + 1
    end
  
    # update
    test "comment can be updated via an update request to /comments/[:id]" do
      new_content = "Some other comment content"
      put comment_url(1, content: new_content), headers: @headers 
      assert comment.find(1).content == new_content
    end
  
    # delete
    test "delete /comments/[:id] deletes a comment" do 
      comment_count_before_delete = comment.count
      delete comment_url(1), headers: @headers
      assert comment.count == comment_count_before_delete - 1
    end
end

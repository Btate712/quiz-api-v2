require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "saves a comment with a user_id, question_id, comment_type, and content" do
    comment = Comment.new(
      user_id: users(:one).id, 
      question_id: questions(:one).id, 
      comment_type: "test",
      content: "Some comment..."
    )
    assert comment.save, "failed to save comment with a user_id, question_id, comment_type, and content"
  end
  
  test "does not save a comment without a user_id" do
    comment = Comment.new(
      question_id: questions(:one).id, 
      comment_type: "test",
      content: "Some comment..."
    )
    assert_not comment.save, "saved comment without a user_id"
  end
  
  test "does not save a comment without a question_id" do
    comment = Comment.new(
      user_id: users(:one).id, 
      comment_type: "test",
      content: "Some comment..."
    )
    assert_not comment.save, "saved comment without a question_id"
  end

  test "does not save a comment without content" do
    comment = Comment.new(
      user_id: users(:one).id,
      comment_type: "test",
      question_id: questions(:one).id
    )
    assert_not comment.save, "saved comment without content"
  end

  test "kill method deletes the comment" do 
    comment_count_before_kill = Comment.count 
    Comment.first.kill
    assert Comment.count == comment_count_before_kill - 1
  end
end

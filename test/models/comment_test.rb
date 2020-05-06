require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "saves a comment with a user_id, question_id, comment_type, and content" do
    project = Project.create(name: "My Project")
    topic = Topic.create(name: "something", project_id: project.id)
    user = User.create(name: "bob", email: "bob@bob.bob", password: "temp")
    question = Question.create(
      stem: "This is the question",
      choice_1: "A",
      choice_2: "B",
      choice_3: "C",
      choice_4: "D",
      correct_choice: 2,
      topic_id: topic.id
    )
    comment = Comment.new(
      user_id: user.id, 
      question_id: question.id, 
      comment_type: "test",
      content: "Some comment..."
    )
    assert comment.save
  end
  
  test "does not save a comment without a user_id" do
    project = Project.create(name: "My Project")
    topic = Topic.create(name: "My Topic", project_id: project.id)
    question = Question.create(
      stem: "This is the question",
      choice_1: "A",
      choice_2: "B",
      choice_3: "C",
      choice_4: "D",
      correct_choice: 2,
      topic_id: topic.id
    )
    comment = Comment.new(
      question_id: question.id, 
      comment_type: "test",
      content: "Some comment..."
    )
    assert_not comment.save
  end
  
  test "does not save a comment without a question_id" do
    user = User.create(name: "bob", email: "bob@bob.bob", password: "temp")
    comment = Comment.new(
      user_id: user.id, 
      comment_type: "test",
      content: "Some comment..."
    )
    assert_not comment.save
  end

  test "does not save a comment without content" do
    project = Project.create(name: "My Project")
    topic = Topic.create(name: "My Topic", project_id: project.id)
    user = User.create(name: "bob", email: "bob@bob.bob", password: "temp")
    question = Question.create(
      stem: "This is the question",
      choice_1: "A",
      choice_2: "B",
      choice_3: "C",
      choice_4: "D",
      correct_choice: 2,
      topic_id: topic.id
    )
    comment = Comment.new(
      user_id: user.id,
      comment_type: "test",
      question_id: question.id
    )
    assert_not comment.save
  end
end

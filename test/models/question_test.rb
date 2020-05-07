require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "saves a question with a stem, four choices, a correct choice, and a topic_id" do
    question = Question.new(
      stem: "This is the question",
      choice_1: "A",
      choice_2: "B",
      choice_3: "C",
      choice_4: "D",
      correct_choice: 2,
      topic_id: topics(:one).id
    )
    assert question.save
  end
  
  test "does not save a question without a stem" do
    question = Question.new(
      choice_1: "A",
      choice_2: "B",
      choice_3: "C",
      choice_4: "D",
      correct_choice: 2,
      topic_id: topics(:one).id
    )
    assert_not question.save
  end
  
  test "does not save a question without a first choice" do
    question = Question.new(
      stem: "This is the question",
      choice_2: "B",
      choice_3: "C",
      choice_4: "D",
      correct_choice: 2,
      topic_id: topics(:one).id
    )
    assert_not question.save
  end
  
  test "does not save a question without a second choice" do
    question = Question.new(
      stem: "This is the question",
      choice_1: "A",
      choice_3: "C",
      choice_4: "D",
      correct_choice: 2,
      topic_id: topics(:one).id
    )
    assert_not question.save
  end
  
  test "does not save a question without a third choice" do
    question = Question.new(
      stem: "This is the question",
      choice_1: "A",
      choice_2: "B",
      choice_4: "D",
      correct_choice: 2,
      topic_id: topics(:one).id
    )
    assert_not question.save
  end
  
  test "does not save a question without a fourth choice" do
    question = Question.new(
      stem: "This is the question",
      choice_1: "A",
      choice_2: "B",
      choice_3: "C",
      correct_choice: 2,
      topic_id: topics(:one).id
    )
    assert_not question.save
  end
  
  test "does not save a question without a correct choice" do
    question = Question.new(
      stem: "This is the question",
      choice_1: "A",
      choice_2: "B",
      choice_3: "C",
      choice_4: "D",
      topic_id: topics(:one).id
    )
    assert_not question.save
  end
  
  test "does not save a question without a topic_id" do
    question = Question.new(
      stem: "This is the question",
      choice_1: "A",
      choice_2: "B",
      choice_3: "C",
      choice_4: "D",
      correct_choice: 2
    )
    assert_not question.save
  end
end

class QuestionsController < ApplicationController
  def index
    questions = Question.all.filter do |question|
      current_user.has_project_rights?(question.topic.project, READ_LEVEL)
    end
    response = {
      message: "#{questions.count} questions retrieved.",
      status: :success,
      questions: questions
    }
    render json: response
  end

  def show 
    question = Question.find_by(id: params[:id])
    if !question 
      response = {
        message: "Unable to find question with id: #{params[:id]}",
        status: :failure
      }
    elsif !current_user.has_project_rights?(question.topic.project, READ_LEVEL)
      response = {
        message: "User does not have access to project #{question.topic.project.name}",
        status: :failure
      }
    else 
      response = {
        message: "Question with id #{params[:id]} retrieved.",
        status: :success,
        question: question
      }
    end 
    render json: response
  end

  def create 
    question = Question.new(question_params)
    if !current_user.has_project_rights?(question.topic.project, WRITE_LEVEL)
      response = {
        message: "User does not have access to project #{question.topic.project.name}",
        status: :failure
      }
    elsif !question.save 
      response = {
        message: "Question failed to save.",
        status: :failure,
        error: question.errors
      }
    else 
      response = {
        message: "Question saved successfully with id: #{question.id}",
        status: :success,
        question: question
      }
    end 
    render json: response
  end

  def update 
    question = Question.find_by(id: params[:id])
    if !question 
      response = {
        message: "Could not find question with id: #{params[:id]}",
        status: :failure
      }
    elsif !current_user.has_project_rights?(question.topic.project)
      response = {
        message: "User does not have access to project #{question.topic.project.name}",
        status: :failure
      }
    elsif !question.update(question_params)
      response = {
        message: "Question failed to update.",
        status: :failure
      }
    else 
      response = {
        message: "Question updated successfully.",
        status: :success,
        question: question
      }
    end
    render json: response
  end

  def destroy 
    question = Question.find_by(id: params[:id])
    if !question 
      response = {
        message: "Could not find question with id: #{params[:id]}",
        status: :failure
      }
    elsif !current_user.has_project_rights?(question.topic.project)
      response = {
        message: "User does not have access to project #{question.topic.project.name}",
        status: :failure
      }
    else  
      question.destroy 
      response = {
        message: "Question with id #{params[:id]} deleted.",
        status: :success
      }
    end 
    render json: response
  end

  def question_params
    params.permit(
      :topic_id,
      :stem,
      :choice_1,
      :choice_2,
      :choice_3,
      :choice_4,
      :correct_choice,
      :image_url
    )
  end
end

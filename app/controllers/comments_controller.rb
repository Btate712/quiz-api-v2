class CommentsController < ApplicationController
  def show
    comment = Comment.find_by(id: params[:id])
    if !comment 
      response = {
        message: "Comment with id: #{params[:id]} not found.",
        status: :failure
      }
    elsif !current_user.has_project_rights?(comment.question.topic.project, READ_LEVEL)
      response = {
        message: "You do not have access to the project in which this comment resides.",
        status: :failure
      } 
    else 
      response = {
        message: "Comment found.",
        comment: comment,
        status: :success
      }
    end
    render json: response
  end

  def create
    comment = Comment.new(comment_params)
    if !current_user.has_project_rights?(comment.question.topic.project, READ_LEVEL)
      response = {
        message: "You do not have access to the project in which this comment resides.",
        status: :failure
      }
    elsif !comment.save 
      response = {
        message: "Comment failed to save.",
        status: :failure,
        error: comment.errors
      }
    else 
      response = {
        message: "Comment saved successfully.",
        status: :success,
        comment: comment
      }
    end
    render json: response
  end

  def update
    comment = Comment.find_by(id: params[:id])
    if !comment
      response = {
        message: "Comment with id: #{params[:id]} not found.",
        status: :failure
      }
    elsif !current_user.has_project_rights?(comment.question.topic.project, WRITE_LEVEL)
      response = {
        message: "User does not have access to project \"#{comment.question.topic.project.name}\".",
        status: :failure
      }
    elsif !comment.update(comment_params)
      response = {
        message: "Comment failed to update.",
        status: :failure,
        error: comment.errors
      }
    else 
      response = {
        message: "Comment updated successfully.",
        status: :success,
        comment: comment
      }
    end
    render json: response
  end

  def delete

  end

  def comment_params
    params.permit(
      :user_id,
      :question_id,
      :comment_type,
      :content
    )
  end
end

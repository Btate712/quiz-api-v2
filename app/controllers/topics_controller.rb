class TopicsController < ApplicationController
  def index
    projects = Project.all.filter{ |project| current_user.has_project_rights?(project, READ_LEVEL)}
    response = projects.map do |project| 
      user_project = project.user_projects.find_by(user_id: current_user.id)
      {
      project_name: project.name,
      access_level: 
        user_project ? project.user_projects.find_by(user_id: current_user.id).access_level : ADMIN_LEVEL,
      is_public: project.is_public,
      topics: project.topics.map{ |topic| {
        topic_id: topic.id,
        topic_name: topic.name,
        number_of_questions: topic.questions.count
      }
      }
    } 
    end
    render json: response
  end
  
  def show
    topic = Topic.all.find(params[:id])
    user_project = topic.project.user_projects.find_by(user_id: current_user.id)
    if (!topic)
      response = {
        message: "Topic with id: #{params[:id]} not found.",
        status: :failure
      }
    elsif(!current_user.has_project_rights?(topic.project))
      response = {
        message: "You do not have read access to topic with id: #{params[:id]}.",
        status: :failure
      }
    else
      response = {
        message: "Topic found.",
        topic: {
          id: topic.id,
          name: topic.name,
          access_level: user_project ? user_project.access_level : ADMIN_LEVEL,
          questions: topic.questions
        },
        status: :success
      }
    end
    render json: response
  end

  def create
    topic = Topic.new(topic_params)
    if(!current_user.has_project_rights?(topic.project))
      response = {
        message: "You do not have sufficient access to add a topic to this project.",
        status: :failure
      }
    elsif(!topic.save) 
      response = {
        message: "Failed to save topic.",
        status: :failure,
        error: topic.errors
      }
    else
      user_project = topic.project.user_projects.find_by(user_id: current_user.id)
      response = {
        message: "New topic created.",
        topic: {
          id: topic.id,
          name: topic.name,
          project_name: topic.project.name,
          project_id: topic.project.id,
          access_level: user_project ? user_project.access_level : ADMIN_LEVEL
        }
      }
    end 
    render json: response
  end

  def update
    topic = Topic.find(params[:id])
    if (!topic)
      response = {
        message: "Topic with id: #{params[:id]} not found.",
        status: :failure
      }
    elsif (!current_user.has_project_rights?(topic.project, WRITE_LEVEL))
      response = {
        message: "You do not have access to modify this topic.",
        status: :failure
      }
    elsif (!topic.update(topic_params))
      response = {
        message: "Failed to update topic.",
        status: :failure,
        error: topic.errors
      }
    else 
      user_project = topic.project.user_projects.find_by(user_id: current_user.id)
      response = {
        message: "Topic updated.",
        topic: {
          id: topic.id,
          name: topic.name,
          project_name: topic.project.name,
          project_id: topic.project.id,
          access_level: user_project ? user_project.access_level : ADMIN_LEVEL
        }, 
        status: :success
      }
    end
    render json: response
  end

  def destroy
    topic = Topic.find(params[:id])
    if (!topic)
      response = {
        message: "Topic with id: #{params[:id]} not found.",
        status: :failure
      }
    elsif (!current_user.has_project_rights?(topic.project, WRITE_LEVEL))
      response = {
        message: "You do not have access to delete this topic.",
        status: :failure
      }
    else 
      topic.kill
      response = {
        message: "Topic deleted.",
        status: :success
      }
    end
  end

  def topic_params
    params.permit(
      :name,
      :project_id
    )
  end
end

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

  end

  def update

  end

  def destroy

  end

  def topic_params

  end
end

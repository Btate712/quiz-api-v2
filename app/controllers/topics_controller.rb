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
        topic_name: topic.name,
        number_of_questions: topic.questions.count
      }
      }
    } 
    end
    render json: response
  end
  
  def show

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

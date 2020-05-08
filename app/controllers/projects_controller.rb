class ProjectsController < ApplicationController
  def index
    projects = Project.all.filter{ |project| current_user.has_project_rights?(project) }
    response = {
      message: "#{projects.count} project#{projects.count > 1 ? 's' : ''} found.",  
      projects: projects.as_json(only: [:name, :is_public]),
      status: :success
    }
    render json: response
  end

  def show 
    project = Project.find_by(id: params[:id])
    if !project 
      response = {
        message: "Project with id #{params[:id]} not found.",
        status: :failure
      }
    elsif !current_user.has_project_rights?(project)
      response = {
        message: "User does not have access to project with id #{params[:id]}.",
        status: :failure
      }
    else
      response = { 
        message: "Project found.",
        project: { 
          id: project.id,
          name: project.name,
          is_public: project.is_public,
          topics: project.topics.map { |topic| { name: topic.name, question_count: topic.questions.count } }
        },
        status: :success
      }
    end
    render json: response
  end
end

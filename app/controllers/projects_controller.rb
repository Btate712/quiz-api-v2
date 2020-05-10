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

  def create 
    project = Project.new(project_params)
    if project.save
      UserProject.create(user_id: current_user.id, project_id: project.id, access_level: WRITE_LEVEL)
      response = {
        message: "Project created with id #{project.id}.",
        project: project.as_json(only: [:id, :name, :is_public]),
        status: :success
      }
    else 
      response = {
        message: "Project failed to save.",
        status: :failure,
        error: project.errors
      }
    end
    render json: response
  end

  def update
    project = Project.find(params[:id])
    if !project
      response = {
        message: "Project with id:#{params[:id]} could not be found.",
        status: :failure
      }
    elsif !current_user.has_project_rights?(project, READ_LEVEL)
      response = {
        message: "You do not have access to modify this project",
        status: :failure
      }
    else
      if project.update(project_params)
        response = {
          message: "Project updated.",
          project: project.as_json(only: [:id, :name, :is_public]),
          status: :success
        }
      else
        response = {
          message: "Project failed to update.",
          status: :failure,
          error: project.errors
        }
      end
    end 
    render json: response 
  end 

  def destroy 
    project = Project.find(params[:id])
    if !project
      response = {
        message: "Project with id:#{params[:id]} could not be found.",
        status: :failure
      }
    elsif !current_user.has_project_rights?(project, READ_LEVEL)
      response = {
        message: "You do not have access to delete this project",
        status: :failure
      }
    else
      project.kill
      response = { 
        message: "User with id: '#{params[:id]}' deleted",
        status: :success
      }
    end
    render json: response
  end

  def project_params
    params.permit(
      :name,
      :is_public
    )
  end
end

class UserProjectsController < ApplicationController
  def index
    projects = Project.all.filter { |project| current_user.has_project_rights?(project, WRITE_LEVEL) }
    user_projects = projects.map do |project|  { name: project.name, id: project.id, 
      users: project.user_projects.all.map { |user_project| { 
          id: user_project.user_id,
          name: user_project.user.name,
          access_level: user_project.access_level
      }}
    }
    end
    render json: { projects: user_projects }
  end

  def show 
    user_project = UserProject.find(params[:id]) 
    render json: {
      user_name: User.find(user_project.user_id).name,
      user_id: user_project.user_id,
      access_level: user_project.access_level,
      project_name: Project.find(user_project.project_id).name,
      project_id: user_project.project_id
    }
  end 

  def create 
    user_project = UserProject.new(user_project_params)
    if user_project.save
      response = {
        message: "User_Project created with id #{user_project.id}.",
        user_project: {
          user_name: User.find(user_project.user_id).name,
          user_id: user_project.user_id,
          access_level: user_project.access_level,
          project_name: Project.find(user_project.project_id).name,
          project_id: user_project.project_id
        },
        status: :success
      }
    else 
      response = {
        message: "User_Project failed to save.",
        status: :failure,
        error: user_project.errors
      }
    end
    render json: response
  end

  def update 
    user_project = UserProject.find(params[:id])
    if(!user_project) 
      response = {
        message: "Could not find user_project with id: #{params[:id]}.",
        status: :failure
      }
    elsif(!current_user.has_project_rights?(Project.find(user_project.project_id), WRITE_LEVEL))
      response = {
        message: "You do not have the required access level to assign users access to project with id: #{user_project.project_id}.",
        status: :failure
      }
    elsif(!user_project.update(user_project_params))
      response = {
        message: "User_Project failed to save.",
        status: :failure,
        error: user_project.errors
      }
    else
      response = {
        message: "User_Project updated.",
        status: :success,
        user_project: {
          user_name: User.find(user_project.user_id).name,
          user_id: user_project.user_id,
          access_level: user_project.access_level,
          project_name: Project.find(user_project.project_id).name,
          project_id: user_project.project_id
        }
      }
    end
    render json: response
  end

  def delete 

  end

  def user_project_params
    params.permit(
      :user_id,
      :project_id,
      :access_level
    )
  end
end

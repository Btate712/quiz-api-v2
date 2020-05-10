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

  end

  def update 

  end

  def delete 

  end
end

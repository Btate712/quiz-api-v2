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
end

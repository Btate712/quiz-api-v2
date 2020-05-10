class UsersController < ApplicationController
  def index
     render json: {
       message: "#{User.count} user#{User.count > 1 ? 's' : ''} found.",
       users: User.all.as_json(only: [:id, :name])
     }
  end

  def create
    new_user = User.new(user_params)

    # set is_admin to false if undefined or keep as true if set as true
    new_user.is_admin = !! new_user.is_admin
    if new_user.save
      response = { 
        message: "New user '#{new_user.name}' created successfully",
        user: new_user.as_json(except: [:password_digest]),
        status: :success
      }
    else
      response = {
        message: "New user failed to save.",
        status: :failure,
        errors: new_user.errors
      }
    end
    render json: response
  end

  def show
    if !current_user.is_admin
      response = {
        message: "Viewing User data requires admin access",
        status: :failure
      }
    elsif !User.find_by(id: params[:id])
      response = {
        message: "User with id: '#{params[:id]}' not found",
        status: :failure
      }
    else
      response = { 
        message: "User #{params[:id]} found.",
        user: User.find_by(id: params[:id]).as_json(only: [:id, :name, :email, :is_admin]),
        status: :success
      }
    end
    render json: response
  end

  def update 
    user = User.find(params[:id]) 
    if !current_user.is_admin && current_user != user
      response = {
        message: "You do not have access to modify this user",
        status: :failure
      }
    elsif !user 
      response = {
        message: "User with id: '#{params[:id]}' not found",
        status: :failure
      }
    else
      if user.update(user_params)
        response = {
          message: "User updated.",
          user: user.as_json(except: [:password_digest]),
          status: :success
        }
      else 
        response = {
          message: "User failed to update.",
          error: user.errors,
          status: :failure
        }
      end
    end
    render json: response
  end

  def destroy
    if !current_user.is_admin
      response = {
        message: "Deleting User data requires admin access",
        status: :failure
      }
    elsif !User.find_by(id: params[:id])
      response = {
        message: "User with id: '#{params[:id]}' not found",
        status: :failure
      }
    else
      user = User.find(params[:id])
      # kill is an instance method that cleans up objects that depend on the user
      # i.e. comments and user_projects
      user.kill
      response = { 
        message: "User with id: '#{params[:id]}' deleted",
        status: :success
      }
    end
    render json: response
  end

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :is_admin
    )
  end
end

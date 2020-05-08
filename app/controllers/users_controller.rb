class UsersController < ApplicationController
  def index
     render json: {
       message: "Users...",
       users: User.all.as_json(only: [:name])
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
        message: "User found.",
        user: User.find_by(id: params[:id]).as_json(except: [:password_digest]),
        status: :success
      }
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
      User.find_by(id: params[:id]).destroy
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

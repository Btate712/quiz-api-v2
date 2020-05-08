class UsersController < ApplicationController
  def index
     render json: {
       message: "Users...",
       users: User.all.as_json(only: [:name, :is_admin])
     }
  end

  def create
    new_user = User.new(user_params)

    # set is_admin to false if undefined or keep as true if set as true
    new_user.is_admin = !! new_user.is_admin
    if new_user.save
      response = { 
        message: "New user '#{new_user.name}' created successfully",
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

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :is_admin
    )
  end
end

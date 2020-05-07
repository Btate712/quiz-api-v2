class UsersController < ApplicationController
  def index
     render json: {
       message: "Users...",
       users: User.all.as_json(only: [:name, :is_admin])
     }
  end
end

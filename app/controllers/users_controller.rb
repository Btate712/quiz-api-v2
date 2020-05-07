class UsersController < ApplicationController
  def index
     render json: {
       message: "Users...",
       users: User.all.as_json(only: [:name])
     }
  end
end

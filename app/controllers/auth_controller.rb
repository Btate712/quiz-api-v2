class AuthController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    @user = User.find_by(name: user_login_params[:username])
    #User#authenticate comes from BCrypt
    if @user && @user.authenticate(user_login_params[:password])
      # encode token comes from ApplicationController
      token = encode_token({ user_id: @user.id })
      render json: { 
        user: @user.as_json(except: [:password_digest, :created_at, :updated_at]), 
        jwt: token 
      }, status: :accepted
    else
      render json: { message: 'Invalid username or password' }, status: :unauthorized
    end
  end

  private

  def user_login_params
    # params {username: 'Chandler Bing', password: 'hi' }
    params.permit(:username, :password)
  end
end

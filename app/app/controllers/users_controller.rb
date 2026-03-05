class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render json: user.to_json, status: :created
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end

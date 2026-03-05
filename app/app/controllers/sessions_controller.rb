class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      render json: user.to_json, status: :ok
    else
      render json: { error: 'invalid credentials' }, status: :unauthorized
    end
  end
end

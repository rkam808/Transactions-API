class TransactionsController < ApplicationController
  before_action :set_user, only: [:create]

  def create
    Transaction.transaction do
      return render json: { error: 'Unauthorized' }, status: :unauthorized unless @user

      @user.lock!

      return render json: { error: 'payment required' }, status: 402 if surpasses_limit?(transaction_params[:amount])

      transaction = Transaction.new(transaction_params)

      if transaction.save
        render json: transaction.to_json, status: 201
      else
        render json: { errors: transaction.errors }, status: 422
      end
    end
  end

  private

  def transaction_params
    params.permit(:amount, :description, :user_id)
  end

  def set_user
    api_key = request.headers['apikey']
    api_key_user = User.find_by_api_key(api_key)

    # Make sure db User associated with this API key is same as requesting User
    return unless api_key_user.id == transaction_params[:user_id]

    @user = api_key_user
  end

  def surpasses_limit?(amount)
    @user.current_amount + amount > 1000
  end
end

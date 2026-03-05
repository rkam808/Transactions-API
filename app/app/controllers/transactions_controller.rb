class TransactionsController < ApplicationController
  before_action :set_user, only: %i[create index]
  # To throttle bad actors (potential Production-grade optimization)
  # before_action rate_limit to: 10, within: 10.minutes, only: :create

  def create
    Transaction.transaction do
      @user.lock!

      return render json: { error: 'payment required' }, status: 402 if surpasses_limit?(transaction_params[:amount]&.to_i)

      transaction = Transaction.new(transaction_params)

      if transaction.save
        render json: transaction.to_json, status: 201
      else
        render json: { errors: transaction.errors }, status: 422
      end
    end
  end

  def index
    transactions = @user.transactions.order(created_at: :desc)

    render json: transactions.to_json, status: :ok
  end

  private

  def transaction_params
    params.permit(:amount, :description, :user_id)
  end

  def set_user
    api_key = request.headers['apikey']
    api_key_user = User.find_by(api_key: api_key)

    return render json: { error: 'Unauthorized' }, status: :unauthorized unless api_key_user

    # Remove this section for realistic API key usage.
      # Make sure db User associated with this API key is same as requesting User
      # if transaction_params[:user_id]&.to_i != api_key_user.id
      #   return render json: { error: 'Mismatched User Identity' }, status: :forbidden
      # end

    @user = api_key_user
  end

  def surpasses_limit?(amount)
    @user.current_amount + amount > 1000
  end
end

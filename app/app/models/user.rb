class User < ApplicationRecord
  validates :api_key, presence: true, uniqueness: true
  has_many :transactions

  # maybe cache this to save on querying
  def current_amount
    Transaction.where(user: self).sum(:amount)
    # SELECT SUM(amount) FROM transactions WHERE user_id = x
  end
end

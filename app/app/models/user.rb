class User < ApplicationRecord
  validates :api_key, presence: true, uniqueness: true
  has_many :transactions

  def self.find_by_api_key(api_key)
    User.find_by(api_key: api_key)
  end

  # maybe cache this to save on querying
  def current_amount
    transactions.pluck(:amount).sum
  end
end

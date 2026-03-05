class User < ApplicationRecord
  has_many :transactions
  has_secure_password validations: false
  before_validation :generate_api_key
  validates :name, presence: true
  validates :api_key, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :frontend_user?
  validates :password, presence: true, on: :create, if: :frontend_user?

  # maybe cache this to save on querying
  def current_amount
    Transaction.where(user: self).sum(:amount)
    # SELECT SUM(amount) FROM transactions WHERE user_id = x
  end

  private

  def generate_api_key
    self.api_key ||= SecureRandom.hex(16)
  end

  def frontend_user?
    email.present? && password.present?
  end
end

class Transaction < ApplicationRecord
  belongs_to :user
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :description, presence: true
  validate :user_within_limit?, on: :create

  private

  def user_within_limit?
    return unless user.present? && amount.present? && amount.is_a?(Integer)

    user.current_amount + amount > 1000 && errors.add(:base, 'User has exceeded the transaction limit of 1000')
  end
end

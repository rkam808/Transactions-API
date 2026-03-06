class Transaction < ApplicationRecord
  belongs_to :user
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :description, presence: true
end

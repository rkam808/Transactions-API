require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    let(:user) { User.create!(name: 'Test User') }

    it 'is invalid without a user' do
      transaction = Transaction.new(amount: 100, description: 'Test transaction')
      expect(transaction).not_to be_valid
      expect(transaction.errors[:user]).to include("must exist")
    end

    it 'is invalid without an amount' do
      transaction = Transaction.new(user: user, description: 'Test transaction')
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include("can't be blank")
    end

    it 'is invalid with a non-integer amount' do
      transaction = Transaction.new(user: user, amount: 10.5, description: 'Test transaction')
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include("must be an integer")
    end

    it 'is invalid with a non-positive amount' do
      transaction = Transaction.new(user: user, amount: -50, description: 'Test transaction')
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include("must be greater than 0")
    end

    it 'is invalid without a description' do
      transaction = Transaction.new(user: user, amount: 100)
      expect(transaction).not_to be_valid
      expect(transaction.errors[:description]).to include("can't be blank")
    end

    it 'is invalid when the user exceeds the transaction limit' do
      transaction = Transaction.new(user: user, amount: 1001, description: 'Test transaction')
      expect(transaction).not_to be_valid
      expect(transaction.errors[:base]).to include('User has exceeded the transaction limit of 1000')
    end
  end
end

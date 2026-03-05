require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'callbacks' do
    let(:user) { User.new(name: 'Callback Test User', email: 'test@example.com', password: 'password123') }

    it 'generates an api_key before validation if one does not exist' do
      expect(user.api_key).to be_nil
      expect { user.valid? }.to change { user.api_key }.from(nil)
      expect(user.api_key).not_to be_nil
    end

    it 'does not overwrite an existing api_key' do
      user.api_key = 'valid_api_key'
      expect { user.valid? }.not_to change { user.api_key }
      expect(user.api_key).to eq('valid_api_key')
    end
  end

  describe 'validations' do
    let(:user) { User.new(name: 'Valid User') }

    it 'is valid as an API user (no email or password)' do
      expect(user).to be_valid
    end

    it 'requires a name' do
      user.name = nil
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    context 'when acting as a frontend user' do
      let(:frontend_user) { User.new(name: 'Frontend User', email: 'test@example.com', password: 'password123') }

      it 'is valid with email and password' do
        expect(frontend_user).to be_valid
      end

      it 'requires a properly formatted email' do
        frontend_user.email = 'not-an-email'
        expect(frontend_user).not_to be_valid
        expect(frontend_user.errors[:email]).to include("is invalid")
      end

      it 'enforces email uniqueness' do
        frontend_user.save!
        duplicate_user = User.new(name: 'Duplicate', email: 'test@example.com', password: 'password123')

        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email]).to include("has already been taken")
      end
    end
  end

  describe '#current_amount' do
    let(:user) { User.create!(name: 'Ledger User') }

    it 'returns 0 when the user has no transactions' do
      expect(user.current_amount).to eq(0)
    end

    context 'when the user has transactions' do
      before do
        5.times do |i|
          Transaction.create!(user: user, amount: (i + 1) * 10, description: "Transaction #{i + 1}")
        end
      end

      it 'calculates the sum of all associated transactions' do
        expect(user.current_amount).to eq(150)
      end

      it 'does not include transactions from other users' do
        other_user = User.create!(name: 'Other User')
        Transaction.create!(user: user, amount: 100, description: 'My money')
        Transaction.create!(user: other_user, amount: 500, description: 'Not my money')

        expect(user.current_amount).to eq(250.00)
      end
    end
  end
end

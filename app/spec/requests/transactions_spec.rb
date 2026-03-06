require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  describe 'POST /transactions' do
    let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'password123') }
    let(:valid_params) do
      {
        amount: 100,
        description: 'Test Transaction'
      }.to_json
    end

    it 'creates a new transaction for the user' do
      post '/transactions', params: valid_params, headers: { 'Content-Type' => 'application/json', 'apiKey' => user.api_key }

      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:created)
      expect(response_body['amount']).to eq(100)
      expect(response_body['description']).to eq('Test Transaction')
      expect(response_body['user_id']).to eq(user.id)
    end

    context 'with missing parameters' do
      let(:invalid_params) do
        {
          description: 'Missing Amount'
        }.to_json
      end

      it 'returns an error when required parameters are missing' do
        post '/transactions', params: invalid_params, headers: { 'Content-Type' => 'application/json',  'apiKey' => user.api_key }

        expect(response).to have_http_status(422)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('error')
        expect(response_body['error']).to eq('Missing Parameters')
      end
    end

    context 'when user exceeds transaction limit' do
      let(:excessive_params) do
        {
          amount: 1001,
          description: 'Excessive Transaction'
        }.to_json
      end

      it 'returns an error when the transaction exceeds the user limit' do
        post '/transactions', params: excessive_params, headers: { 'Content-Type' => 'application/json',  'apiKey' => user.api_key }

        expect(response).to have_http_status(402)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('error')
        expect(response_body['error']).to eq('payment required')
      end
    end
  end
end

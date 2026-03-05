require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /signup' do
    let(:valid_params) do
      {
        user: {
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123'
        }
      }.to_json
    end

    it 'creates a new user with valid parameters' do
      post '/signup', params: valid_params, headers: { 'Content-Type' => 'application/json', 'Origin' => 'http://localhost:3000' }

      puts "RESPONSE BODY: #{response.body}"
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['name']).to eq('Test User')
      expect(JSON.parse(response.body)).to have_key('api_key')
    end

    context 'with missing parameters' do
      let(:invalid_params) do
        {
          user: {
            email: 'test@example.com'
          }
        }.to_json
      end

      it 'returns an error when required parameters are missing' do
        post '/signup', params: invalid_params, headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to have_key('errors')
        expect(JSON.parse(response.body)['errors']).to have_key('password')
      end
    end
  end
end

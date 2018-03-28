require 'rails_helper'

RSpec.describe 'User Registration', type: :request do
  let(:headers) { { HTTP_ACCEPT: 'application/json' } }

  context 'with valid credentials' do
    it 'returns a user and token' do
      post '/api/auth', params: {
        email: 'me@mail.com', password: 'whatever',
        password_confirmation: 'whatever'
      }, headers: headers

      expect(JSON.parse(response.body)['status']).to eq 'success'
      expect(response.status).to eq 200
    end
  end

  context 'returns an error message when user submits' do
    it 'non-matching password confirmation' do
      post '/api/auth', params: {
        email: 'me@mail.com', password: 'whatever',
        password_confirmation: 'Whatever'
      }, headers: headers

      expect(JSON.parse(response.body)['errors']['password_confirmation']).to eq ["doesn't match Password"]
      expect(response.status).to eq 422
    end

    it 'an invalid email address' do
      post '/api/auth', params: {
        email: 'me@mail', password: 'whatever',
        password_confirmation: 'whatever'
      }, headers: headers

      expect(JSON.parse(response.body)['errors']['email']).to eq ['is not an email']
      expect(response.status).to eq 422
    end

    it 'an already registered email' do
      create(:user, email: 'me@mail.com',
                    password: 'whatever',
                    password_confirmation: 'whatever')

      post '/api/auth', params: {
        email: 'me@mail.com', password: 'whatever',
        password_confirmation: 'whatever'
      }, headers: headers

      expect(JSON.parse(response.body)['errors']['email']).to eq ['has already been taken']
      expect(response.status).to eq 422
    end
  end

  describe 'OmniAuth' do
    context 'Facebook' do

      let(:params) { {omniauth_window_type: 'newWindow'} }
      let(:request) { lambda do
        get('/api/auth/facebook/',
            params: params,
            headers: headers)
        follow_redirect! until response.status == 200
      end }

      it 'allows user to register with valid authorization' do
        # Uses default mock, set in support/oauth.rb
        expect { request.call }.to change(User, :count).by(1)
      end

      it 'fails to register user with invalid authorization' do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
        expect { request.call }.to change(User, :count).by(0)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) {FactoryBot.create(:user)}
  let(:headers) {{HTTP_ACCEPT: 'application/json'}}

  describe 'POST /api/auth/sign_in' do
    it 'valid credentials returns user' do
      post '/api/auth/sign_in', params: {
          email: user.email, password: user.password
      }, headers: headers

      expected_response = {
          'data' => {'id' => user.id,
                     'email' => 'thomas@craftacademy.se',
                     'provider' => 'email',
                     'latitude' => nil,
                     'longitude' => nil,
                     'uid' => 'thomas@craftacademy.se',
                     'role' => 'visitor',
                     'address' => nil
          }
      }
      expect(JSON.parse(response.body)).to eq expected_response
    end

    it 'invalid password returns error message' do
      post '/api/auth/sign_in', params: {
          email: user.email, password: 'wrong_password'
      }, headers: headers

      expect(JSON.parse(response.body)['errors'])
          .to eq ['Invalid login credentials. Please try again.']
      expect(response.status).to eq 401
    end

    it 'invalid email returns error message' do
      post '/api/auth/sign_in', params: {
          email: 'wrong@email.com', password: user.password
      }, headers: headers

      expect(JSON.parse(response.body)['errors'])
          .to eq ['Invalid login credentials. Please try again.']
      expect(response.status).to eq 401
    end
  end

  describe 'DELETE /api/auth/sign_out' do

    before do
      post '/api/auth/sign_in', params: {
          email: user.email, password: user.password
      }, headers: headers
      @headers = {'access-token' => response.headers['access-token'],
                  uid: response.headers['uid'],
                  client: response.headers['client'],
                  HTTP_ACCEPT: 'application/json'}

    end

    it 'logs out a logged in user' do
      delete '/api/auth/sign_out', headers: @headers
      expect(JSON.parse(response.body)['success']).to eq true
    end
  end
end

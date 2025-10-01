# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /api/v1/users' do
    it 'returns list of users (id, name, banned)' do
      create(:user, name: 'Alice')
      create(:user, name: 'Bob')
      create(:user, name: 'Charlie', banned: true)

      get '/api/v1/users'
      expect(response).to have_http_status(:ok)
      expect(json).to be_an(Array)
      expect(json.size).to eq(3)

      first = json.first
      expect(first.keys).to contain_exactly('id', 'name', 'banned')
    end
  end
end

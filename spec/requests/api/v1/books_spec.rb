# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Books', type: :request do
  describe 'GET /api/v1/books' do
    it 'return list of books (id, title, author)' do
      create(:book, title: 'Clean Code')
      create(:book, title: 'Pragmatic Programmer')
      create(:book, title: 'Refactoring')

      get '/api/v1/books'
      expect(response).to have_http_status(:ok)
      expect(json).to be_an(Array)
      expect(json.size).to eq(3)

      first = json.first
      expect(first.keys).to contain_exactly('id', 'title', 'author')
    end
  end
end

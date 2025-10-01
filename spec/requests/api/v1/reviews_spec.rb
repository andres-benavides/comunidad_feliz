# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Reviews', type: :request do
  describe 'GET /api/v1/reviews' do
    it 'returns a list with nested user and book' do
      user = create(:user, name: 'Alice')
      book = create(:book, title: 'Clean Code')
      create(:review, user: user, book: book, rating: 5, content: 'Excellent')
      create(:review, user: create(:user, name: 'Bob'), book: create(:book, title: 'PragProg'), rating: 4)

      get '/api/v1/reviews'
      expect(response).to have_http_status(:ok)
      expect(json).to be_an(Array)
      expect(json.size).to eq(2)

      item = json.first
      expect(item.keys).to contain_exactly('id', 'rating', 'content', 'created_at', 'user', 'book')
      expect(item['user'].keys).to contain_exactly('id', 'name', 'banned')
      expect(item['book'].keys).to contain_exactly('id', 'title', 'author')
    end
  end

  describe 'POST /api/v1/reviews' do
    let(:user) { create(:user) }
    let(:book) { create(:book) }

    it 'creates a valid review' do
      post '/api/v1/reviews', params: {
        review: { user_id: user.id, book_id: book.id, rating: 5, content: 'Very good' }
      }

      expect(response).to have_http_status(:created)
      expect(json.keys).to contain_exactly('id', 'rating', 'content', 'created_at', 'user', 'book')
      expect(json['rating']).to eq(5)
      expect(json['book']['id']).to eq(book.id)
      expect(json['user']['id']).to eq(user.id)
    end

    it 'rejects creation if the user is banned' do
      banned = create(:user, banned: true)
      post '/api/v1/reviews', params: {
        review: { user_id: banned.id, book_id: book.id, rating: 5 }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include('User is banned')
    end

    it 'rejects duplicate (same user/book pair)' do
      create(:review, user: user, book: book, rating: 4)
      post '/api/v1/reviews', params: {
        review: { user_id: user.id, book_id: book.id, rating: 5 }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors'].join).to match(/Review already exists/i)
    end

    it 'rejects rating out of range' do
      post '/api/v1/reviews', params: {
        review: { user_id: user.id, book_id: book.id, rating: 10 }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors'].join).to match(/rating/i)
    end
  end
end

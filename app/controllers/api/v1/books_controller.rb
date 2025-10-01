# frozen_string_literal: true

module Api
  module V1
    class BooksController < BaseController
      def index
        books = Book.order(:title)
        render json: books.map { |b| BookSerializer.new(b).as_json }
      end
    end
  end
end
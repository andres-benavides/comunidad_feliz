# frozen_string_literal: true

class ReviewSerializer < ApplicationSerializer
  def as_json(*)
    {
      id: record.id,
      rating: record.rating,
      content: record.content,
      created_at: record.created_at,
      user: UserSerializer.new(record.user).as_json,
      book: BookSerializer.new(record.book).as_json
    }
  end
end

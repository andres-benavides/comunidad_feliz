# frozen_string_literal: true

class BookRatingCalculator
  Result = Struct.new(:average, :count, :status, keyword_init: true)

  INSUFFICIENT_LABEL = 'Insufficient Reviews'.freeze

  def self.call(book)
    new(book).call
  end

  def initialize(book)
    @book = book
  end

  def call
    scope = @book.reviews.from_active_users
    stats = scope.select('COUNT(*) AS c, AVG(rating) AS avg').take
    count = stats&.c.to_i

    if count < 3
      Result.new(average: nil, count: count, status: INSUFFICIENT_LABEL)
    else
      avg = stats.avg&.to_f
      Result.new(average: avg&.round(1), count: count, status: nil)
    end
  end
end
class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :title, :author, presence: true

  def rating_summary
    BookRatingCalculator.call(self)
  end

end

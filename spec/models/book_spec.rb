# spec/models/book_spec.rb
require 'rails_helper'

RSpec.describe Book, type: :model do
  it { is_expected.to have_many(:reviews).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:author) }

  it 'rating_summary usa BookRatingCalculator' do
    book = build(:book)
    expect(BookRatingCalculator).to receive(:call).with(book)
    book.rating_summary
  end
end

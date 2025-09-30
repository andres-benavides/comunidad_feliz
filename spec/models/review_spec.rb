# spec/models/review_spec.rb
require 'rails_helper'

RSpec.describe Review, type: :model do
  subject { build(:review) }

  it { is_expected.to belong_to(:book) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:rating) }
  it { is_expected.to validate_inclusion_of(:rating).in_range(1..5) }

  it 'permite content nil' do
    review = build(:review, content: nil)
    expect(review).to be_valid
  end

  it 'no permite content > 1000 chars' do
    review = build(:review, content: 'a' * 1001)
    expect(review).not_to be_valid
  end

  it 'scope from_active_users excluye baneados' do
    active = create(:user)
    banned = create(:user, :banned)
    book = create(:book)
    r1 = create(:review, user: active, book: book)
    create(:review, user: banned, book: book)

    expect(book.reviews.from_active_users).to contain_exactly(r1)
  end
end

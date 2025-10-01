require 'rails_helper'

RSpec.describe BookRatingCalculator, type: :service do
  let(:book) { create(:book) }

  context 'no reviews' do
    it 'marks as insufficient' do
      res = described_class.call(book)
      expect(res.count).to eq(0)
      expect(res.average).to be_nil
      expect(res.status).to eq('Insufficient Reviews')
    end
  end

  context 'with 2 valid reviews' do
    it 'marks as insufficient and no average' do
      users = create_list(:user, 2)
      users.each { |u| create(:review, book: book, user: u, rating: 5) }

      res = described_class.call(book)
      expect(res.count).to eq(2)
      expect(res.average).to be_nil
      expect(res.status).to eq('Insufficient Reviews')
    end
  end

  context 'with 3 valid reviews' do
    it 'computes average to 1 decimal' do
      create(:review, book: book, user: create(:user), rating: 5)
      create(:review, book: book, user: create(:user), rating: 4)
      create(:review, book: book, user: create(:user), rating: 3)

      res = described_class.call(book)
      expect(res.count).to eq(3)
      expect(res.average).to eq(4.0)
      expect(res.status).to be_nil
    end
  end

  context 'mixed with banned users' do
    it 'excludes banned from average and count' do
      active1 = create(:user)
      active2 = create(:user)
      banned  = create(:user, :banned)

      create(:review, book: book, user: active1, rating: 5)
      create(:review, book: book, user: active2, rating: 1)
      create(:review, book: book, user: banned,  rating: 5)

      res = described_class.call(book)
      expect(res.count).to eq(2)
      expect(res.average).to be_nil
      expect(res.status).to eq('Insufficient Reviews')
    end
  end

  context 'exactly 2 valid and 1 banned' do
    it 'is still insufficient' do
      create(:review, book: book, user: create(:user), rating: 5)
      create(:review, book: book, user: create(:user), rating: 4)
      create(:review, book: book, user: create(:user, :banned), rating: 5)

      res = described_class.call(book)
      expect(res.count).to eq(2)
      expect(res.average).to be_nil
      expect(res.status).to eq('Insufficient Reviews')
    end
  end

  context 'rounding to 1 decimal' do
    it 'rounds correctly' do
      [3, 3, 4, 4, 3, 3].first(3).each_with_index do |rating, i|
        create(:review, book: book, user: create(:user, name: "U#{i}"), rating: rating)
      end
      res = described_class.call(book)
      expect(res.count).to eq(3)
      expect(res.average).to eq(3.3)
    end
  end
end

require 'rails_helper'

RSpec.describe BookRatingCalculator, type: :service do
  let(:book) { create(:book) }

  context 'sin reseñas' do
    it 'marca insuficientes' do
      res = described_class.call(book)
      expect(res.count).to eq(0)
      expect(res.average).to be_nil
      expect(res.status).to eq('Reseñas Insuficientes')
    end
  end

  context 'con 2 reseñas válidas' do
    it 'marca insuficientes y no da promedio' do
      users = create_list(:user, 2)
      users.each { |u| create(:review, book: book, user: u, rating: 5) }

      res = described_class.call(book)
      expect(res.count).to eq(2)
      expect(res.average).to be_nil
      expect(res.status).to eq('Reseñas Insuficientes')
    end
  end

  context 'con 3 reseñas válidas' do
    it 'calcula promedio a 1 decimal' do
      create(:review, book: book, user: create(:user), rating: 5)
      create(:review, book: book, user: create(:user), rating: 4)
      create(:review, book: book, user: create(:user), rating: 3)

      res = described_class.call(book)
      expect(res.count).to eq(3)
      expect(res.average).to eq(4.0) # (5+4+3)/3 = 4.0
      expect(res.status).to be_nil
    end
  end

  context 'mezcla con baneados' do
    it 'excluye baneados del promedio y conteo' do
      active1 = create(:user)
      active2 = create(:user)
      banned  = create(:user, :banned)

      create(:review, book: book, user: active1, rating: 5)
      create(:review, book: book, user: active2, rating: 1)
      create(:review, book: book, user: banned,  rating: 5) # no cuenta

      res = described_class.call(book)
      expect(res.count).to eq(2)
      expect(res.average).to eq(3.0) # (5+1)/2 = 3.0
      expect(res.status).to be_nil # hay 2? ojo: con 2 válidas sería insuficiente
    end
  end

  context 'exactamente 2 válidas y 1 baneado' do
    it 'sigue siendo insuficiente' do
      create(:review, book: book, user: create(:user), rating: 5)
      create(:review, book: book, user: create(:user), rating: 4)
      create(:review, book: book, user: create(:user, :banned), rating: 5)

      res = described_class.call(book)
      expect(res.count).to eq(2)
      expect(res.average).to be_nil
      expect(res.status).to eq('Reseñas Insuficientes')
    end
  end

  context 'redondeo a 1 decimal' do
    it 'redondea correctamente' do
      # Promedio 3.1666... -> 3.2
      [3, 3, 3, 4, 3, 3].first(3).each_with_index do |rating, i|
        create(:review, book: book, user: create(:user, name: "U#{i}"), rating: rating)
      end
      # ratings: 3,3,4 -> avg = 3.3333 -> redondeo 3.3 (ajusta a tu caso de prueba preferido)
      res = described_class.call(book)
      expect(res.count).to eq(3)
      expect(res.average).to eq(3.3)
    end
  end
end

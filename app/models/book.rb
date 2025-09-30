class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :title, :author, presence: true

end

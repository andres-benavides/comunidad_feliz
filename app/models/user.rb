class User < ApplicationRecord
  has_many :reviews, dependent: :nullify

  validates :name, presence: true
end

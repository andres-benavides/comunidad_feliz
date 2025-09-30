class User < ApplicationRecord
  has_many :reviews, dependent: :nullify

end

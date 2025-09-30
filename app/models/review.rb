class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, length: { maximum: 1000 }, allow_nil: true

end

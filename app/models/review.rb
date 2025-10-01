class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, length: { maximum: 1000 }, allow_nil: true

  validates :user_id, uniqueness: { scope: :book_id, message: 'has already reviewed this book' }

  scope :from_active_users, -> { joins(:user).where(users: { banned: false }) }

end

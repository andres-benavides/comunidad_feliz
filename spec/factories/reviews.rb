FactoryBot.define do
  factory :review do
    association :book
    association :user
    rating { 4 }
    content { "Nice book" }
  end
end
FactoryBot.define do
  factory :user do
    name { "User #{SecureRandom.hex(3)}" }
    banned { false }

    trait :banned do
      banned { true }
    end
  end
end
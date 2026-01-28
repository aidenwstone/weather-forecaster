FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end

    password { "Password123" }
    password_confirmation { "Password123" }
  end
end

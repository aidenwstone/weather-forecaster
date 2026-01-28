FactoryBot.define do
  factory :location do
    address { "404 Ghost St, Nowhereville USA" }
    nickname { "Home" }
    latitude { 40.7128 }
    longitude { 74.0060 }
    timezone { "America/New_York" }
    name { "Nowhereville" }
    user

    trait :with_ip do
      address { nil }
      ip_address { "192.0.2.0" }
    end
  end
end

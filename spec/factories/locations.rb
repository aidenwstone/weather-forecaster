FactoryBot.define do
  factory :location do
    address { "404 Ghost St, Nowhereville USA" }
    ip_address { "" }
    nickname { "Home" }
    latitude { 40.7128 }
    longitude { 74.0060 }
    timezone { "America/New_York" }
    name { "Nowhereville" }
    user

    trait :with_ip do
      address { "" }
      ip_address { "192.0.2.0" }
    end
  end
end

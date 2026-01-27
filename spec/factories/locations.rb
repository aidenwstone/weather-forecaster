FactoryBot.define do
  factory :location do
    address { "MyString" }
    ip_address { "MyString" }
    nickname { "MyString" }
    latitude { "9.99" }
    longitude { "9.99" }
    timezone { "MyString" }
    name { "MyString" }
    user { nil }
  end
end

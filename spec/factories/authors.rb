FactoryBot.define do
  factory :author do
    name { Faker::Book.author }
    kind { :person }
    birth_date { Date.new(1970, 1, 1) }

    trait :institution do
      kind { :institution }
      city { "Recife" }
      birth_date { nil }
    end
  end
end
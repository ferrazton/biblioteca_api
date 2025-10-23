FactoryBot.define do
  sequence :isbn13 do |n|
    "978%010d" % n
  end

  sequence :doi_str do |n|
    "10.1000/#{1000 + n}"
  end

  factory :material do
    association :user
    association :author
    title { Faker::Book.title }
    status { :draft }

    trait :book do
      kind  { :book }
      isbn  { generate(:isbn13) }
      pages { 200 }
    end

    trait :article do
      kind { :article }
      doi  { generate(:doi_str) }
    end

    trait :video do
      kind     { :video }
      duration { 300 }
    end
  end
end

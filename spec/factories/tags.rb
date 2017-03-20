FactoryGirl.define do
  factory :tag do
    name { Faker::Internet.slug }
  end
end

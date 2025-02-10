FactoryBot.define do
  factory :post do
    title { "Sample Post" }
    content { "This is a sample post content." }
    association :user
  end
end
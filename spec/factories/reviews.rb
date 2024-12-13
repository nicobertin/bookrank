FactoryBot.define do
  factory :review do
    book
    user
    rating { 5 }
    content { "Great book!" }
  end
end
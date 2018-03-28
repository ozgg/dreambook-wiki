FactoryBot.define do
  factory :word do
    language
    sequence(:body) { |n| "Слово #{n}" }
  end
end

FactoryBot.define do
  factory :pattern do
    language
    sequence(:title) { |n| "Образ #{n}" }
    interpretation "Более детальная интерпретация"
  end
end

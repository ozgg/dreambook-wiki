FactoryBot.define do
  factory :word do
    language { nil }
    processed { false }
    weight { 1 }
    patterns_count { 1 }
    body { "MyString" }
  end
end

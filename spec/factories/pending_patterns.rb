FactoryBot.define do
  factory :pending_pattern do
    pattern { nil }
    processed { false }
    name { "MyString" }
  end
end

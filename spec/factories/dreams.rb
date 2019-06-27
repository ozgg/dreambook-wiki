FactoryBot.define do
  factory :dream do
    user { nil }
    agent { nil }
    ip { "" }
    personal { false }
    comments_count { 1 }
    title { "MyString" }
    body { "MyText" }
  end
end

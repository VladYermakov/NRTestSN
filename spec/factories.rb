FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@site.com" }
    password "password"
  end

  factory :article do
    sequence(:title)   { |n| "Article #{n}" }
    sequence(:content) { |n| "Lorem ipsum content in article #{n}" }
    user
  end

  factory :comment do
    sequence(:content) { |n| "Comment #{n} for some article" }
    article
    user
  end
end

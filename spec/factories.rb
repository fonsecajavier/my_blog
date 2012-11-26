FactoryGirl.define do
  factory :user do
    sequence(:full_name) {|n| "Fulano De Tal N#{n}"}
    sequence(:email) {|n| "fulano_#{n}@detal.com"}
    password "password"
  end

  factory :post do
    title "My imaginative title"
    content "Don't know what to put in here"
    user

    factory :invalid_post do
      title ""
    end
  end

  factory :comment do
    post
    nickname "whoever you want"
    message "hey nice thoughts!"

    factory :invalid_comment do
      nickname ""
    end
  end
end
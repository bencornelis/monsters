FactoryGirl.define do
  factory :user do
    username "watiki"
    password "12345678"
    email "watiki@gmail.com"
  end

  factory :post do
    title "What are your favorite game soundtracks?"
  end

end

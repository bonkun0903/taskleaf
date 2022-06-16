FactoryBot.define do
  factory :user do
    name { 'テスユーザー' }
    email { 'test@example.com'}
    password { 'password' }
  end 
end
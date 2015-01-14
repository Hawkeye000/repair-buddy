FactoryGirl.define do
  factory :user do
    name "John Doe"
    email "johndoe@example.com"
    password "password"
    password_confirmation "password"
  end

  # This will use the User class (Admin would have been guessed)
  factory :invalid_user, parent: :user do
    name "J"
    email "johndoe@example.com"
    password "password"
    password_confirmation "password"
  end
end

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

  factory :car do
    edmunds_id 100344072
    make "Honda"
    model "Civic"
    year 2004
    trim "EX 4dr Sedan (1.7L 4cyl 5M)"
    user_id 1
  end

  factory :invalid_car, parent: :car do
    trim ""
  end

  factory :record do
    record_type "Maintenance"
    user_id 1
    car_id 1
    mileage 100
    short_title "Oil Change"
    description "Routine oil change"
    cost 21.50
    date DateTime.now.to_date
  end

  factory :invalid_record, parent: :record do
    record_type ""
  end
end

require 'rails_helper'

describe 'Signing up new Users' do

  let(:user_attrs) { attributes_for(:user) }

  it "should permit signing up Users" do
    visit new_user_registration_path
    within("#new_user") {
      fill_in :name, with:user_attrs[:name]
      fill_in :email, with:user_attrs[:email]
      fill_in :password, with:user_attrs[:password]
      fill_in :password_confirmation, with:user_attrs[:password_confirmation]
    }
    expect {
      click_button "Sign up"
    }.to change(User, :count).by(1)

  end

  context "user is signed in" do
    let(:user) { create(:user) }

    xit "allows adding cars to the 'garage'", js:true do
      login_as user
      visit new_user_car_path(user.id)
      VCR.use_cassette('user_filling_car_search_form') do
        within('#car_form #new_car') {
          select "2004", from:"car_year"
          select "Honda", from:"car_make"
          select "Civic", from:"car_model"
          select "EX 4dr Sedan (1.7L 4cyl 5M)", from:"car_trim"
        }
      end
      expect {
        click_button "Add Car to Garage"
      }.to change(Car, :count).by(1)
    end
  end

  after do |example|
    if example.exception != nil
      save_and_open_page
    end
  end

end

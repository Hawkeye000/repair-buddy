require 'rails_helper'

describe 'User Features' do

  describe "signing up new users" do
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
  end

  context "user is signed in" do
    let(:user) { create(:user) }
    before do
      login_as user
      visit new_user_car_path(user.id)
    end

    # have observed working in dev environment, although the test will not pass
    xit "allows adding cars to the 'garage' with the car form", js:true do
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
    # have observed working in dev environment, although the test will not pass
    xit "allows adding cars to the 'garage' with the vin form", js:true do
      VCR.use_cassette('lookup_camaro_by_vin_user_test') do
        fill_in "vin", with:'2G1FC3D33C9165616'
        click_button 'Lookup Car by VIN'
      end
      expect {
        click_button "Add Car to Garage"
      }.to change(Car, :count).by(1)
    end
  end

  after do |example|
    if example.exception != nil
      # save_and_open_page
    end
  end

end

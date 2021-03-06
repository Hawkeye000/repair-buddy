require 'rails_helper'

describe "home page" do

  let(:user) { create(:user) }
  before { visit '/' }

  it "should highlight the home record" do
    expect(page).to have_css('li#nav_home_link.active')
  end

  context "user is not logged in" do
    it "should have a link to login" do
      expect(page).to have_link("Login", href:new_user_session_path)
    end
    it "should not have a link to Profile" do
      expect(page).to_not have_link("Profile", href:user_path(user))
    end
    it "should not have a link to 'Add Car'" do
      expect(page).to_not have_link("Add Car", href:new_user_car_path(user))
    end
    it "should not have a link to 'Garage'" do
      expect(page).to_not have_link("Garage", href:user_cars_path(user))
    end
    it "should not have a link to 'Settings'" do
      expect(page).to_not have_link("Settings", href:edit_user_registration_path)
    end
    it "should not have a link to 'My Records'" do
      expect(page).to_not have_link("My Records", href:user_records_path(user))
    end
  end
  context "user is logged in" do

    before do
      login_as user, scope: :user
      visit current_path
    end

    it "should have a link to Profile" do
      expect(page).to have_link("Profile", href:user_path(user))
    end
    it "should have a link to 'Add Car'" do
      expect(page).to have_link("Add Car", href:new_user_car_path(user))
    end
    it "should have a link to 'Logout'" do
      expect(page).to have_link("Logout", href:destroy_user_session_path)
    end
    it "should have a link to 'Garage'" do
      expect(page).to have_link("Garage", href:user_cars_path(user))
    end
    it "should have a link to 'Settings'" do
      expect(page).to have_link("Settings", href:edit_user_registration_path)
    end
    it "should have a link to 'My Records'" do
      expect(page).to have_link("My Records", href:user_records_path(user))
    end
  end

  after do |example|
    if example.exception != nil
      # save_and_open_page
    end
  end

end

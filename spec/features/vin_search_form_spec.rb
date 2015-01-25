require 'rails_helper'

describe "lookup by VIN", vcr:true do

  before do
    user = create(:user)
    login_as(user, scope: :user, :run_callbacks => false)
    visit new_user_car_path(user)
  end

  it "should have a 'Lookup Car by VIN' button" do
    expect(page).to have_css('input.btn[value="Lookup Car by VIN"]')
  end

  it "should have a text box to do lookup by VIN" do
    expect(page).to have_css('input#vin')
  end

  context "less than 17 characters in the VIN text box" do
    it "should have the button blocked out" do
      expect(page).to have_css('input#submit-vin[disabled=disabled]')
    end
  end

  context "equal to 17 characters in the VIN text box" do
    it "should enable the button", js:true do
      fill_in "vin", with:'2G1FC3D33C9165616'
      expect(page).to_not have_css('input#submit-vin[disabled=disabled]')
    end
  end

  describe "clicking the 'Lookup' button" do
    before do
      VCR.use_cassette('lookup_camaro_by_vin') do
        fill_in "vin", with:'2G1FC3D33C9165616'
        click_button 'Lookup Car by VIN'
      end
    end
    it "should make an ajax request and render the result", js:true do
      expect(page).to have_content('Chevrolet')
      expect(page).to have_content('Camaro')
      expect(page).to have_content('2012')
      expect(page).to have_content('LT 2dr Convertible w/2LT (3.6L 6cyl 6M)')
    end
    it "should make visible an 'Add to Garage' button", js:true do
      expect(page).to have_selector('#vin-add-to-garage', visible:true)
    end
  end

  after do |example|
    if example.exception != nil
      save_and_open_page
    end
  end

end

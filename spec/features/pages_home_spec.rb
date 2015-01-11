require 'rails_helper'

describe "shared/car_form" do

  before do
    VCR.use_cassette('edmunds_makes_car_form') do
      visit '/'
    end
  end

  it "should have a select tag called 'Year'" do
    expect(page).to have_css("select#year")
  end
  it "should have a select tag called 'Make' which is disabled" do
    expect(page).to have_css("select#make[disabled=disabled]")
  end
  it "should have a select tag called 'Model' which is disabled" do
    expect(page).to have_css('select#model[disabled=disabled]')
  end
  it "should have a select tag called 'Trim' which is disabled" do
    expect(page).to have_css('select#trim[disabled=disabled]')
  end

  describe "lookup by VIN" do
    it "should have a 'Lookup Car by VIN' button" do
      expect(page).to have_css('input.btn[value="Lookup Car by VIN"]')
    end

    it "should have a text box to do lookup by VIN" do
      expect(page).to have_css('input#vin')
    end

    context "less than 17 characters in the VIN text box" do
      it "should have the button blocked out" do
        expect(page).to have_css('input.btn[disabled=disabled]')
      end
    end

    context "equal to 17 characters in the VIN text box" do
      it "should enable the button", js:true do
        fill_in "vin", with:"a"*17
        expect(page).to_not have_css('input.btn[disabled=disabled]')
      end
    end

  end

end

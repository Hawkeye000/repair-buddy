require 'rails_helper'

describe "lookup by VIN", vcr:true do
  before { visit '/' }

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

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
  it "should have a text box to do lookup by VIN" do
    expect(page).to have_css('input#vin')
  end
  
end

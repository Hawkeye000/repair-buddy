require 'rails_helper'

describe "self.list_of_auto_makes", vcr:true do

  before do
    VCR.use_cassette 'edmunds_makes' do
      @makes = Edmunds.list_of_auto_makes(params:{ api_key:Rails.application.secrets.edmunds_api_key })
    end
  end

  it "should return an array of strings" do
    @makes.each { |make| expect(make).to be_a String }
  end

  it "should include 'Acura'" do
    expect(@makes).to include('Acura')
  end

end

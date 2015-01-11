require 'rails_helper'

describe "self.list_of_auto_makes", vcr:true do

  before do
    VCR.use_cassette 'edmunds_makes' do
      @all_makes = Edmunds.list_of_auto_makes(params:{ api_key:Rails.application.secrets.edmunds_api_key })
    end
  end

  context "without year" do

    it "should return an array of strings" do
      @all_makes.each { |make| expect(make).to be_a String }
    end

    it "should include 'Eagle'" do
      expect(@all_makes).to include('Eagle')
    end
  end

  context "passing a year parameter" do
    before do
      VCR.use_cassette 'edmunds_makes_from_2004' do
        params = { params: { api_key:Rails.application.secrets.edmunds_api_key,
                             year:2004 } }
        @makes_from_2005 = Edmunds.list_of_auto_makes(params)
      end
    end

    it "should not include non-current makes" do
      expect(@makes_from_2005).to_not include('Eagle')
    end

    it "should include a current make from that year" do
      expect(@makes_from_2005).to include('Honda')
    end

    it "should be a subset of @all_makes" do
      expect(@makes_from_2005 - @all_makes).to be_empty
      expect(@all_makes.length).to be > @makes_from_2005.length
    end

  end

  context "passing nil for year" do
    before do
      VCR.use_cassette 'edmunds_makes_from_blank' do
        params = { params: { api_key:Rails.application.secrets.edmunds_api_key,
                             year:"" } }
        @makes_from_blank = Edmunds.list_of_auto_makes(params)
      end
    end

    it "should return a blank list" do
      expect(@makes_from_blank).to be_empty
    end
  end

end

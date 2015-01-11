require 'rails_helper'

describe "self#list_of_auto_makes", vcr:true do

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

describe "self#list_of_auto_models", vcr:true do

  context "make name is one word" do
    before do
      VCR.use_cassette 'edmunds_models_2004_honda' do
        @models_2004_honda = Edmunds.list_of_auto_models("Honda",
        params: { api_key:Rails.application.secrets.edmunds_api_key,
                  year:2004 })
      end
    end

    it "should return a list of models" do
      expect(@models_2004_honda).to_not be_empty
    end
    it "should include 'Civic'" do
      expect(@models_2004_honda).to include('Civic')
    end
  end

  context "model name is two words" do
    before do
      VCR.use_cassette 'edmunds_models_2012_aston_martin' do
        @models_2012_aston_martin = Edmunds.list_of_auto_models("Aston Martin",params:
            { api_key:Rails.application.secrets.edmunds_api_key,
              year:2012 })
      end
    end

    it "should return a list of models" do
      expect(@models_2012_aston_martin).to_not be_empty
    end
    it "should include 'DB9'" do
      expect(@models_2012_aston_martin).to include('DB9')
    end
  end

  context "model name is two words in snake case" do
    before do
      VCR.use_cassette 'edmunds_models_2012_aston_martin' do
        @models_2012_aston_martin = Edmunds.list_of_auto_models("aston_martin",params:
            { api_key:Rails.application.secrets.edmunds_api_key,
              year:2012 })
      end
    end

    it "should return a list of models" do
      expect(@models_2012_aston_martin).to_not be_empty
    end
    it "should include 'DB9'" do
      expect(@models_2012_aston_martin).to include('DB9')
    end
  end

end

describe "self#list_of_auto_styles" do

  it "should return a hash of IDs and style names" do
    VCR.use_cassette 'edmunds_models_2012_aston_martin_db9' do
      @models_2012_aston_martin_db9 = Edmunds.list_of_auto_styles(
          "Aston Martin", "DB9", 2012, params:
          { api_key:Rails.application.secrets.edmunds_api_key })
    end
    expect(@models_2012_aston_martin_db9).to be_a(Hash)
    expect(@models_2012_aston_martin_db9.values).to include("Volante Luxury Edition 2dr Convertible (5.9L 12cyl 6A)")
  end

end

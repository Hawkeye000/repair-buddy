require 'rails_helper'

RSpec.describe EdmundsMakesController, :type => :controller do

  describe "edmunds_makes#index" do

    context "with no year" do
      it "provides an empty array" do
        VCR.use_cassette('edmunds_makes_from_blank') do
          get :index, format: :json
        end
        expect(JSON.parse(response.body)).to be_empty
      end
    end

    context "with a year" do
      it "provides a list of makes" do
        VCR.use_cassette('edmunds_makes_from_2004') do
          get :index, {year:'2004', format: :json}
        end
        expect(JSON.parse(response.body)).to include('Honda')
        expect(JSON.parse(response.body)).to_not be_empty
      end
    end
    
  end
end

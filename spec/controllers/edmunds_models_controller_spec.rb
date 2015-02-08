require 'rails_helper'

RSpec.describe EdmundsModelsController, :type => :controller do

  describe "edmunds_models#index", vcr:true do

    context "with no year" do
      xit "provides an empty array" do
        VCR.use_cassette('edmunds_models_nil_year_aston_martin') do
          get :index, { make:"Aston Martin", format: :json }
        end
        expect(JSON.parse(response.body)).to be_empty
      end
    end

    context "with a year" do
      it "provides a list of models" do
        VCR.use_cassette('edmunds_models_2012_aston_martin') do
          get :index, {year:'2012', make:"Aston Martin", format: :json}
        end
        expect(JSON.parse(response.body)).to include('DB9')
        expect(JSON.parse(response.body)).to_not be_empty
      end
    end

  end

end

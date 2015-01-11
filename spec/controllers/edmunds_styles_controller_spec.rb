require 'rails_helper'

RSpec.describe EdmundsStylesController, :type => :controller do

  describe "edmunds_styles#index", vcr:true do

    context "with year, make, and model" do
      it "provides a list of trim styles" do
        VCR.use_cassette('edmunds_styles_2004_honda_civic') do
          get :index, { make:"Honda", year:"2004", model:"Civic", format: :json }
        end
        expect(JSON.parse(response.body).values).to include('EX 4dr Sedan (1.7L 4cyl 5M)')
      end
    end

    context "with no year" do
      xit "provides an empty array" do
        VCR.use_cassette('edmunds_styles_honda_civic_no_year') do
          get :index, { make:"Honda", model:"Civic", format: :json }
        end
        expect(JSON.parse(response.body)).to be_empty
      end
    end

  end

end

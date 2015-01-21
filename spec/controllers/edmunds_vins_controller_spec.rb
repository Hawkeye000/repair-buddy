require 'rails_helper'

RSpec.describe EdmundsVinsController, :type => :controller do

  describe "Edmunds#car_lookup_by_vin", vcr:true do
    it "should return Make, Model, Trim, Year, and Edmunds ID" do
      VCR.use_cassette('edmunds_vin_lookup_2G1FC3D33C9165616') do
        get :show, { vin:"2G1FC3D33C9165616", format: :json }
      end
      expect(JSON.parse(response.body).values).to include('Chevrolet')
      expect(JSON.parse(response.body).values).to include('Camaro')
      expect(JSON.parse(response.body).values).to include(2012)
      expect(JSON.parse(response.body).values).to include('LT 2dr Convertible w/2LT (3.6L 6cyl 6M)')
      expect(JSON.parse(response.body).values).to include(101395591)
    end
  end

end

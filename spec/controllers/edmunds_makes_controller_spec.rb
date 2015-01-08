require 'rails_helper'

RSpec.describe EdmundsMakesController, :type => :controller do
  
  describe 'GET #index' do
    it "should deny html request" do
      get :index, format: :html
      expect(response).to have_http_status(406)
    end
  end

end

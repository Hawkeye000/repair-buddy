require 'rails_helper'

RSpec.describe CarsController, :type => :controller do

  let(:user) { create(:user) }

  describe 'GET#new' do

    context "user signed in" do
      before { sign_in user }
      it "should assign Car#new to @car" do
        get :new, user_id:user
        expect(assigns(:car)).to be_a_new(Car)
      end
      it "should render the :new view" do
        get :new, user_id:user
        expect(response).to render_template :new
      end
    end
    context "user not signed in" do
      it "should redirect to the sign_in page" do
        get :new, user_id:user
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST#create' do

    context "user signed in" do
      before { sign_in user }
    end

  end

end

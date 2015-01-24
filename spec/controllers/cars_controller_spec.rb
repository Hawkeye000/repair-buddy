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
      context "valid parameters" do
        it "saves the car in a database" do
          expect {
            post :create, user_id:user.id, car: attributes_for(:car)
          }.to change(Car, :count).by(1)
        end
        it "associates the car with the user" do
          post :create, user_id:user.id, car: attributes_for(:car)
          expect(user.cars.first.edmunds_id).to eq(build(:car).edmunds_id)
        end
      end
      context "invalid parameters" do
        it "does not save the car in a database" do
          expect {
            post :create, user_id:user.id, car: attributes_for(:invalid_car)
          }.to_not change(Car, :count)
        end
      end

    end

  end

end

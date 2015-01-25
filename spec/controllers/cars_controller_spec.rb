require 'rails_helper'

RSpec.describe CarsController, :type => :controller do

  let(:user) { create(:user) }

  describe 'GET#index' do
    context "user signed in" do
      before { sign_in user }
      it "should assign Car#where(user_id==user.id) to @cars" do
        car = create(:car)
        create(:car, user_id:2)
        get :index, user_id:user
        expect(assigns(:cars)).to eq([car])
      end
      it "renders the index view" do
        get :index, user_id:user
        expect(response).to render_template :index
      end
    end
    context "user not signed in" do
      it "does not render the index view" do
        get :index, user_id:user
        expect(response).to_not render_template :index
      end
      it "redirects to the sign_in page" do
        get :index, user_id:user
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

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

  describe 'DELETE#destroy' do
    before { @car = create(:car, user_id:user.id) }
    context "user signed in" do
      before { sign_in user }
      it "removes the car from the database" do
        expect {
          delete :destroy, user_id:user.id, id:@car.id
        }.to change(Car, :count).by(-1)
      end
      it "redirects back to the index" do
        delete :destroy, user_id:user.id, id:@car.id
        expect(response).to redirect_to user_cars_path(user.id)
      end
    end
    context "user not signed in" do
      it "does not remove the car from the database" do
        expect{
          delete :destroy, user_id:user.id, id:@car.id
        }.to_not change(Car, :count)
      end
    end
  end

end

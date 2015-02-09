require 'rails_helper'

RSpec.describe CarsController, :type => :controller do

  let(:user) { create(:user) }
  let(:other_user) { create(:user, name:"Jane Doe", email:"jane@example.com") }

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
      before { get :index, user_id:user }
      it "does not render the index view" do
        expect(response).to_not render_template :index
      end
      it "redirects to the sign_in page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "current_user.id doesn't match params[:user_id]" do
      before do
        sign_in other_user
        get :index, user_id:user
      end
      it "does not render the index view" do
        expect(response).to_not render_template :index
      end
      it "redirects to that user's garage" do
        expect(response).to redirect_to user_cars_path(other_user.id)
      end
    end
  end

  describe 'GET#show' do
    context "user signed in" do
      let(:car) { create(:car) }
      before do
        sign_in user
        VCR.use_cassette 'get_show_car_details' do
          car.get_style_details
          car.get_photo_url
        end
        car.save!
        get :show, user_id:user, id:car
      end
      it "assigns the car to @car" do
        expect(assigns(:car)).to eq(car)
      end
      it "renders the show view" do
        expect(response).to render_template :show
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
            VCR.use_cassette 'create_car' do
              post :create, user_id:user.id, car: attributes_for(:car)
            end
          }.to change(Car, :count).by(1)
        end

        before do
          VCR.use_cassette 'create_car' do
            post :create, user_id:user.id, car: attributes_for(:car)
          end
        end
        it "associates the car with the user" do
          expect(user.cars.first.edmunds_id).to eq(build(:car).edmunds_id)
        end
        it "redirects to the 'Garage'" do
          expect(response).to redirect_to user_cars_path(user.id)
        end
        it "has a photo url" do
          expect(Car.last.photo_url).to_not be_nil
        end
        it "has a model year id" do
          expect(Car.last.model_year_id).to_not be_nil
        end
        it "has a transmission type" do
          expect(Car.last.transmission_type).to_not be_nil
        end
        it "has an engine code" do
          expect(Car.last.transmission_type).to_not be_nil
        end
      end
      context "invalid parameters" do
        it "does not save the car in a database" do
          expect {
            VCR.use_cassette 'create_invalid_car' do
              post :create, user_id:user.id, car: attributes_for(:invalid_car)
            end
          }.to_not change(Car, :count)
        end
      end
      context "current_user.id doesn't match params[:user_id]" do
        before do
          sign_in other_user
        end
        it "does not save the car in a database" do
          expect {
            VCR.use_cassette 'create_invalid_car' do
              post :create, user_id:user.id, car: attributes_for(:invalid_car)
            end
          }.to_not change(Car, :count)
        end
      end
    end
  end

  describe 'DELETE#destroy' do
    before do
      @car = create(:car, user_id:user.id)
      @car2 = create(:car, user_id:user.id)
    end
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
    context "current_user.id doesn't match params[:user_id]" do
      before do
        sign_in other_user
      end
      it "does not delete the car from the database" do
        expect {
          delete :destroy, user_id:user.id, id:@car.id
        }.to_not change(Car, :count)
      end
    end
  end

end

require 'rails_helper'

RSpec.describe RecordsController, :type => :controller do

  let(:user) { create(:user) }
  let(:car) { create(:car, user_id:user.id) }

  describe 'GET#index' do
    it "populates an array of records" do
      record = create(:record)
      get :index, user_id:user, car_id:car
      expect(assigns(:records)).to eq([record])
    end
    it "renders the index view" do
      get :index, user_id:user, car_id:car
      expect(response).to render_template :index
    end
  end

  describe 'GET#show' do
    it "assigns the requested record to @record" do
      record = create(:record)
      get :show, user_id:user, car_id:car, id:record
      expect(assigns(:record)).to eq(record)
    end
    it "renders the show view" do
      get :show, user_id:user, car_id:car, id:create(:record)
      expect(response).to render_template :show
    end
  end

  describe 'GET#new' do
    it "assigns record#new" do
      get :new, user_id:user, car_id:car
      expect(assigns(:record)).to be_a_new(Record)
    end
    it "renders the new view" do
      get :new, user_id:user, car_id:car
      expect(response).to render_template :new
    end
  end

  describe 'POST#create' do
    context "with valid attributes" do
      it "creates a new record" do
        expect {
          post :create, user_id:user, car_id:car, record:attributes_for(:record)
        }.to change(Record, :count).by(1)
      end
      it "redirects to the new record" do
        post :create, user_id:user, car_id:car, record:attributes_for(:record)
        latest_record = Record.last
        response.should redirect_to user_car_record_path(latest_record.user_id, latest_record.car_id, latest_record.id)
      end
    end

    context "with invalid attributes" do
      it "does not create a new record" do
        expect {
          post :create, user_id:user, car_id:car, record:attributes_for(:invalid_record)
        }.to_not change(Record, :count)
      end
      it "re-renders the new view" do
        post :create, user_id:user, car_id:car, record:attributes_for(:invalid_record)
        response.should render_template :new
      end
    end
  end

  describe 'GET#edit' do
    let(:record) { create(:record) }
    it "assigns the requested record to @record" do
      get :edit, user_id:user, car_id:car, id:record
      expect(assigns(:record)).to eq(record)
    end
    it "renders the edit view" do
      get :edit, user_id:user, car_id:car, id:record
      expect(response).to render_template :edit
    end
  end

  describe 'PUT#update' do
    let(:record) { create(:record) }
    context "with valid parameters" do
      it "locates the requested record" do
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:record)
        expect(assigns(:record)).to eq(record)
      end
      it "updates the requested record" do
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:record, record_type:"Repair")
        record.reload
        expect(record.record_type).to eq("Repair")
      end
      it "redirects to the updated record" do
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:record)
        expect(response).to redirect_to user_car_record_path(record.user_id, record.car_id, record.id)
      end
    end

    context "with invalid parameters" do
      it "locates the requested record" do
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:invalid_record)
        expect(assigns(:record)).to eq(record)
      end
      it "does not update the requested record" do
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:invalid_record, record_type:"Foobar")
        record.reload
        expect(record.record_type).to_not eq("Foobar")
        expect(record.record_type).to eq("Maintenance")
      end
      it "re-renders the edit page" do
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:invalid_record)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE#destroy' do
    let(:record) { create(:record) }
    it "assigns the requested record to @record" do
      get :destroy, user_id:user, car_id:car, id:record
      expect(assigns(:record)).to eq(record)
    end
    it "redirects to the index view" do
      get :destroy, user_id:user, car_id:car, id:record
      expect(response).to redirect_to user_car_records_path(user.id, car.id)
    end
  end

end

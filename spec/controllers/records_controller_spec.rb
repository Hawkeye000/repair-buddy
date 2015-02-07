require 'rails_helper'

RSpec.describe RecordsController, :type => :controller do

  let(:user) { create(:user) }
  let(:car) { create(:car, user_id:user.id) }

  describe 'GET#index' do

    let(:car2) { create(:car) }
    let(:records) { [create(:record, car_id:car.id), create(:record, car_id:car2.id)] }

    context 'user signed in' do
      before { sign_in user }
      context 'car_id given' do
        it "populates an array of records" do
          get :index, user_id:user, car_id:car
          expect(assigns(:records)).to eq([records[0]])
        end
        it "renders the index view" do
          get :index, user_id:user, car_id:car
          expect(response).to render_template :index
        end
      end
      context 'no car_id given' do
        it "populates an array of all records" do
          get :index, user_id:user
          expect(assigns(:records)).to eq(records)
        end
        it "renders the index view" do
          get :index, user_id:user
          expect(response).to render_template :index
        end
      end
    end

    context 'user not signed in' do
      it 'redirects to the sign in page' do
        get :index, user_id:user
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user != records sought user' do
      it 'redirects to the root page' do
        user2 = create(:user, email:'user2@example.com')
        sign_in user2
        get :index, user_id:user
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET#show' do
    let(:record) { create(:record) }
    context "user record owner signed in" do
      before { sign_in user }
      it "assigns the requested record to @record" do
        get :show, user_id:user, car_id:car, id:record
        expect(assigns(:record)).to eq(record)
      end
      it "renders the show view" do
        get :show, user_id:user, car_id:car, id:record
        expect(response).to render_template :show
      end
    end

    context "user not signed in" do
      it "redirects to the sign_in page" do
        get :show, user_id:user, car_id:car, id:record
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "current_user != user record owner" do
      before { sign_in create(:user, email:'wrong_user@example.com') }
      it "redirects to the sign_in page" do
        get :show, user_id:user, car_id:car, id:record
        expect(response).to redirect_to new_user_session_path
      end
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
    context "user signed in" do
      before { sign_in user }
      context "with valid attributes" do
        it "creates a new record" do
          expect {
            post :create, user_id:user, car_id:car, record:attributes_for(:record)
          }.to change(Record, :count).by(1)
        end
        it "redirects to the new record" do
          post :create, user_id:user, car_id:car, record:attributes_for(:record)
          latest_record = Record.last
          expect(response).to redirect_to user_car_record_path(latest_record.user_id, latest_record.car_id, latest_record.id)
        end
        it "contains all permitted attributes" do
          post :create, user_id:user, car_id:car, record:attributes_for(:record)
          expect(Record.last.attributes).to include(attributes_for(:record).stringify_keys)
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
          expect(response).to render_template :new
        end
      end
    end

    context "user not signed in" do
      it "does not create a new record" do
        expect {
          post :create, user_id:user, car_id:car, record:attributes_for(:record)
        }.to_not change(Record, :count)
      end
      it "renders the sign_in view" do
        post :create, user_id:user, car_id:car, record:attributes_for(:invalid_record)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "user != current_user" do
      it "does not create a new record" do
        sign_in create(:user, email:"wronguser@example.com")
        expect {
          post :create, user_id:user, car_id:car, record:attributes_for(:record)
        }.to_not change(Record, :count)
      end
    end
  end

  describe 'GET#edit' do
    let(:record) { create(:record) }
    context "user record owner signed in" do
      before do
        sign_in user
        get :edit, user_id:user, car_id:car, id:record
      end
      it "assigns the requested record to @record" do
        expect(assigns(:record)).to eq(record)
      end
      it "renders the edit view" do
        expect(response).to render_template :edit
      end
    end

    context "user not signed in" do
      it "redirects to the sign_in page" do
        get :edit, user_id:user, car_id:car, id:record
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "current_user != user record owner" do
      before { sign_in create(:user, email:'wrong_user@example.com') }
      it "redirects to the sign_in page" do
        get :edit, user_id:user, car_id:car, id:record
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT#update' do
    let(:record) { create(:record) }
    context "user record owner signed in" do
      before { sign_in user }
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

    context "user not signed in" do
      it "does not update the requested record" do
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:record, record_type:"Repair")
        record.reload
        expect(record.record_type).to_not eq("Repair")
        expect(record.record_type).to eq("Maintenance")
      end
      it "renders the sign_in view" do
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:record, record_type:"Repair")
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "user != current_user" do
      it "does not update the record" do
        sign_in create(:user, email:"wronguser@example.com")
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:record, record_type:"Repair")
        record.reload
        expect(record.record_type).to_not eq("Repair")
        expect(record.record_type).to eq("Maintenance")
      end
    end
  end

  describe 'DELETE#destroy' do
    let(:record) { create(:record) }
    context "user record owner signed in" do
      before { sign_in user }
      it "assigns the requested record to @record" do
        delete :destroy, user_id:user, car_id:car, id:record
        expect(assigns(:record)).to eq(record)
      end
      it "redirects to the index view" do
        delete :destroy, user_id:user, car_id:car, id:record
        expect(response).to redirect_to user_car_records_path(user.id, car.id)
      end
      it "destroys the record" do
        delete :destroy, user_id:user, car_id:car, id:record
        expect{ Record.find(record.id) }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context "user not signed in" do
      it "does not destroy the requested record" do
        delete :destroy, user_id:user, car_id:car, id:record
        expect{ Record.find(record.id) }.not_to raise_error
      end
      it "renders the sign_in view" do
        put :update, user_id:user, car_id:car, id:record, record:attributes_for(:record, record_type:"Repair")
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "user != current_user" do
      before { sign_in create(:user, email:"wronguser@example.com") }
      it "does not destroy the requested record" do
        delete :destroy, user_id:user, car_id:car, id:record
        expect{ Record.find(record.id) }.not_to raise_error
      end
    end
  end

end

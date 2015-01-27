require 'rails_helper'

describe "new record page" do

  context "with valid parameters" do
    let(:user) { create(:user) }
    let(:car) { create(:car, user_id:user.id) }
    let(:new_record) { build(:record) }

    context "user signed in" do
      context "default radio button" do
        it "creates a new record" do
          login_as user
          visit new_user_car_record_path(user_id:user.id, car_id:car.id)
          fill_in :record_mileage, with:new_record.mileage
          fill_in :record_description, with:"Foobar"
          expect{click_button 'Add Record'}.to change(Record, :count).by(1)
        end
      end
    end
  end

end

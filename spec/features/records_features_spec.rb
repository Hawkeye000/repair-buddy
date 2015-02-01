require 'rails_helper'

describe "new record page" do

  context "with valid parameters" do
    let(:user) { create(:user) }
    let(:car) { create(:car, user_id:user.id) }
    let(:new_record) { build(:record) }

    context "user signed in" do
      context "default radio button" do
        before do
          login_as user
          visit new_user_car_record_path(user_id:user.id, car_id:car.id)
          fill_in :record_mileage, with:new_record.mileage
          fill_in :record_description, with:"Foobar"
          fill_in :record_short_title, with:"Oil Change"
          fill_in :record_cost, with:"21.50"
        end
        it "creates a new record" do
          expect{click_button 'Add Record'}.to change(Record, :count).by(1)
        end
        it "shows a rendered page with the input information" do
          click_button 'Add Record'
          expect(page).to have_content(new_record.mileage)
          expect(page).to have_content("Foobar")
          expect(page).to have_content("Oil Change")
          expect(page).to have_content("Maintenance")
          expect(page).to have_content("21.50")
        end
      end
    end
  end
end

describe "show record page" do

  let(:user) { create(:user) }
  let(:car) { create(:car) }
  let(:record) { create(:record) }

  context "user signed in" do
    before do
      login_as user
      visit user_car_record_path(user_id:user.id, car_id:car.id, id:record.id)
    end
    it "has a link to edit the record" do
      expect(page).to have_link('Edit Record', href:edit_user_car_record_path(user_id:user.id, car_id:car.id, id:record.id))
    end
    it "has a link to the car page" do
      expect(page).to have_link("#{car.year} #{car.make} #{car.model}", href:user_car_path(user_id:user.id, id:car.id))
    end
    it "has a link to destroy the record" do
      expect(page).to have_link('Delete Record', href:user_car_record_path(user_id:user.id, car_id:car.id, id:record.id))
    end
    it "deletes the record if the 'Delete Record' button is pressed" do
      expect {click_link_or_button 'Delete Record'}.to change(Record, :count).by(-1)
    end
  end
end

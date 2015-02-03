require 'rails_helper'

describe "records features" do
  let(:user) { create(:user) }
  let(:car) { create(:car) }
  let(:record) { create(:record) }
  let(:new_record) { build(:record) }

  describe "new record page" do
    context "with valid parameters" do
      context "user signed in" do
        context "default radio button" do
          before do
            login_as user
            visit new_user_car_record_path(user_id:user.id, car_id:car.id)
            fill_in :record_mileage, with:new_record.mileage
            fill_in :record_short_title, with:"Oil Change"
            fill_in :record_cost, with:new_record.cost
            fill_in :record_date, with:new_record.date
          end
          it "creates a new record" do
            expect{click_button 'Add Record'}.to change(Record, :count).by(1)
          end
          context "there is a description entered" do
            it "shows a rendered page with the input information" do
              fill_in :record_description, with:"Foobar"
              click_button 'Add Record'
              expect(page).to have_content(new_record.mileage)
              expect(page).to have_content("Foobar")
              expect(page).to have_content("Oil Change")
              expect(page).to have_content("Maintenance")
              expect(page).to have_content("21.50")
              expect(page).to have_content(new_record.date.month)
              expect(page).to have_content(new_record.date.day)
              expect(page).to have_content(new_record.date.year)
            end
          end
          context "there is no description entered" do
            it "does not contain the description, or its header" do
              click_button 'Add Record'
              expect(page).to_not have_content("Description")
              expect(page).to_not have_content("Foobar")
            end
          end
        end
      end
    end
  end

  describe "show record page" do
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
        record_to_delete = create(:record)
        visit user_car_record_path(user_id:user.id, car_id:car.id, id:record_to_delete.id)
        expect {click_link_or_button 'Delete Record'}.to change(Record, :count).by(-1)
      end
    end
  end

  describe "edit record page" do
    context "user signed in" do
      before do
        login_as user
        visit edit_user_car_record_path(user_id:user.id, car_id:car.id, id:record.id)
      end
      context "with valid parameters" do
        it "updates the record" do
          fill_in :record_mileage, with:new_record.mileage
          fill_in :record_short_title, with:"Oil Change"
          fill_in :record_cost, with:new_record.cost
          fill_in :record_date, with:new_record.date
          fill_in :record_description, with:"Foobar-Foobar"
          click_button 'Update Record'
          expect(Record.find(record.id).description).to eq("Foobar-Foobar")
        end
      end
    end
  end

  describe "records index page" do
    context "user signed in" do
      before do
        login_as user
        @record = create(:record, user_id:user.id, car_id:car.id)
      end
      context "car_id given" do
        before { visit user_car_records_path(user_id:user.id, car_id:car.id) }
        it "has a link to the car" do
          expect(page).to have_link("#{car.year} #{car.make} #{car.model}", href:user_car_path(user_id:user.id, id:car.id))
        end
        it "has a link to the record" do
          expect(page).to have_link(@record.short_title, href:user_car_record_path(user_id:user.id, car_id:car.id, id:@record.id))
        end
        it "has the date" do
          expect(page).to have_content(@record.print_date)
        end
      end
      context "no car_id given" do
        before { visit user_records_path(user_id:user.id) }
        it "has a table entry with the car name" do
          within(:css, 'table') {
            expect(page).to have_link("#{car.year} #{car.make} #{car.model}", href:user_car_path(user_id:user.id, id:car.id))
          }
        end
      end
    end
  end

  after do |example|
    if example.exception != nil
      save_and_open_page
    end
  end

end

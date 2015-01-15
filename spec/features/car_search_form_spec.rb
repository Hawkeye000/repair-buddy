require 'rails_helper'

describe "car searching with parameters", vcr:true do

  before do
    user = create(:user)
    login_as(user, scope: :user, :run_callbacks => false)
    visit new_user_car_path(user)
  end

  describe "Find by Parameters" do
    it "should have a select tag called 'Year'" do
      expect(page).to have_css("select#year")
    end
    it "should have a select tag called 'Make' which is disabled" do
      expect(page).to have_css("select#make[disabled=disabled]")
    end
    it "should have a select tag called 'Model' which is disabled" do
      expect(page).to have_css('select#model[disabled=disabled]')
    end
    it "should have a select tag called 'Trim' which is disabled" do
      expect(page).to have_css('select#trim[disabled=disabled]')
    end

    describe "selecting a year" do

      before do
        VCR.use_cassette('edmunds_makes_from_2004') do
          select "2004", from:"year"
        end
      end

      it "should enable the select tag 'Make' after selecting a year", js:true do
        expect(page).to_not have_css('select#make[disabled=disabled]')
      end
      it "should contain a list of selectables", js:true do
        # count is actually 47, but includes the "select year"
        expect(page).to have_selector('select#make option', count:48)
      end

      context "default reselected" do
        before { select "Select Year...", from:"year" }
        it "should disable the select tag 'Make'", js:true do
          expect(page).to have_css('select#make[disabled=disabled]')
        end
      end

      describe "selecting a make" do
        before do
          VCR.use_cassette('edmunds_models_2004_honda') do
            select "Honda", from:"make"
          end
        end

        it "should enable the select tag 'Model' after selecting a make", js:true do
          expect(page).to_not have_css('select#model[disabled=disabled]')
        end
        it "should contain a list of selectables", js:true do
          # count is actually 8, but includes the "select model"
          expect(page).to have_selector('select#model option', count:9)
        end
        it "should contain the item 'Civic'", js:true do
          expect(page).to have_css('select#model option', text:'Civic')
        end

        context "default reselected" do
          before { select "Select Make...", from:"make" }
          it "should disable the select tag 'Model'", js:true do
            expect(page).to have_css('select#model[disabled=disabled]')
          end
        end

        describe "selecting a model" do
          before do
            VCR.use_cassette('edmunds_styles_2004_honda_civic') do
              select "Civic", from:"model"
            end
          end

          it "should enable the select tag 'Trim'", js:true do
            expect(page).to_not have_css('select#trim[disabled=disabled]')
          end
          it "should contain a list of selectables", js:true do
            # count is actually 8, but includes the "select model"
            expect(page).to have_selector('select#model option', count:9)
          end
          it "should contain a the item 'Hybrid 4dr Sedan (1.3L 4cyl gas/electric hybrid CVT)'", js:true do
            expect(page).to have_css('select#trim option', text:'Hybrid 4dr Sedan (1.3L 4cyl gas/electric hybrid CVT)')
          end

          context "default reselected" do
            before { select "Select Model...", from:"model" }
            it "should disable the select tag 'Trim'", js:true do
              expect(page).to have_css('select#trim[disabled=disabled]')
            end
          end

        end
      end
    end

  end
end

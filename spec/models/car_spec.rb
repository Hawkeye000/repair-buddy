require 'rails_helper'

RSpec.describe Car, :type => :model do
  describe "associations" do
    it { should have_many :records }
    it { should belong_to :user }
  end

  describe "validations" do
    describe "presence validators" do
      it { should validate_presence_of :edmunds_id }
      it { should validate_presence_of :make }
      it { should validate_presence_of :model }
      it { should validate_presence_of :year }
      it { should validate_presence_of :trim }
      it { should validate_presence_of :user_id }
    end
    describe "year format" do
      it { should_not allow_value(21000).for(:year) }
      it { should_not allow_value(381).for(:year) }
      it { should allow_value(2004).for(:year) }
    end
  end

  describe "fixed (dependent) data columns" do
    # these columns are filled in by interacting with the
    # edmunds api and are not set by the user
    it { should respond_to :engine_code }
    it { should respond_to :transmission_type }
    it { should respond_to :photo_url }
    it { should respond_to :model_year_id }

    let(:car) { create(:car) }

    describe "car#get_style_details" do
      before do
        VCR.use_cassette "car_default_get_style_details" do
          car.get_style_details
        end
      end
      it "adds an engine code" do
        expect(car.engine_code).to eq("4INAG1.7")
      end
      it "adds a transmission type" do
        expect(car.transmission_type).to eq("MANUAL")
      end
      it "adds a model year id" do
        expect(car.model_year_id).to eq(100503590)
      end
    end
    describe "car#get_photo_url" do
      before do
        VCR.use_cassette "car_default_get_photo_url" do
          car.get_photo_url
        end
      end
      it "adds a photo url" do
        expect(car.photo_url).to include("/honda/civic/2004/oem/2004_honda_civic_sedan_ex_fq_oem_3_500.jpg")
      end
    end
  end

  describe "factories" do
    it "should have a valid factory" do
      expect(build(:car)).to be_valid
    end
    it "should have an invalid factory" do
      expect(build(:invalid_car)).to_not be_valid
    end
  end

  describe "self.latest_mileage" do
    it "returns the last service record's mileage" do
      car = create(:car)
      create(:record, car_id:car.id, mileage:65000)
      create(:record, car_id:car.id, mileage:48000)
      expect(car.latest_mileage).to eq(65000)
    end
  end

  describe "self.mileage_rate" do
    let(:car) { create(:car) }
    before do
      create(:record, car_id:car.id, mileage:65000, date:DateTime.new(2015, 1, 1))
      create(:record, car_id:car.id, mileage:48000, date:DateTime.new(2014, 1, 1))
    end
    it "returns the average miles put on in a year" do
      expect(car.mileage_rate(:year)).to be_within(24.0).of(17000)
    end
    it "returns the average miles put on in a month" do
      expect(car.mileage_rate(:month)).to be_within(2.0).of(1416.67)
    end
    it "returns the average miles put on in a day" do
      expect(car.mileage_rate(:day)).to be_within(2.0).of(46.6)
    end
    it "returns the aveerage miles put on in a week" do
      expect(car.mileage_rate(:week)).to be_within(10.0).of(326.9)
    end
  end

end

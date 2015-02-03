require 'rails_helper'

RSpec.describe Record, :type => :model do
  describe "associations" do
    it { should belong_to :car }
    it { should have_many(:parts).through(:part_records) }
  end

  describe "validations" do
    it { should allow_value("Maintenance").for(:record_type) }
    it { should allow_value("Repair").for(:record_type) }
    it { should_not allow_value("a").for(:record_type) }
    it { should_not allow_value("").for(:record_type) }

    it { should_not allow_value(-1).for(:mileage) }
    it { should allow_value(70000).for(:mileage) }

    it { should validate_presence_of :short_title }

    it { should allow_value(21.50).for(:cost) }
    it { should_not allow_value(-21.50).for(:cost) }
    it { should allow_value(0).for(:cost) }

    it { should validate_presence_of :date }
  end

  describe "factories" do
    it "should have a valid factory" do
      expect(build(:record)).to be_valid
    end
    it "should have an invalid factory" do
      expect(build(:invalid_record)).to_not be_valid
    end
  end

  describe "print_date" do
    it "prints the format Month(Text) Day(00), Year(0000)" do
      record = build(:record, date:DateTime.new(2000, 1, 1).to_date)
      expect(record.print_date).to eq("January 1, 2000")
    end
  end
end

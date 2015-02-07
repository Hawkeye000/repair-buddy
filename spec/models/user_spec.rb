require 'rails_helper'

RSpec.describe User, :type => :model do

  describe "associations" do
    it { should have_many :cars }
    it { should have_many(:records).through(:cars) }
  end

  describe "validations" do
    describe "name" do
      it { should validate_presence_of :name }
      it { should allow_value("John Smith").for(:name) }
      it { should_not allow_value("J").for(:name) }
      it { should allow_value("John Jacob Smith").for(:name) }
      it { should_not allow_value("_J smith").for(:name) }
    end
  end

  it { should respond_to :name }
  it { should respond_to :admin? }

  it "should have a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "should have an invalid factory" do
    expect(build(:invalid_user)).to_not be_valid
  end
end

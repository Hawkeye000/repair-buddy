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
end

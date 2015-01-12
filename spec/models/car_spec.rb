require 'rails_helper'

RSpec.describe Car, :type => :model do
  describe "associations" do
    it { should have_many :records }
    it { should belong_to :user }
  end

  describe "validations" do
    it { should validate_presence_of :edmunds_id }
    it { should validate_presence_of :make }
    it { should validate_presence_of :model }
    it { should validate_presence_of :year }
    it { should validate_presence_of :trim }
  end
end

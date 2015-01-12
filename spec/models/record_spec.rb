require 'rails_helper'

RSpec.describe Record, :type => :model do
  describe "associations" do
    it { should belong_to :car }
    it { should have_many(:parts).through(:part_records) }
  end
end

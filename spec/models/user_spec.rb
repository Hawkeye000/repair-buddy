require 'rails_helper'

RSpec.describe User, :type => :model do

  describe "associations" do
    it { should have_many :cars }
    it { should have_many(:records).through(:cars) }
  end
  
  it { should respond_to :name }
end

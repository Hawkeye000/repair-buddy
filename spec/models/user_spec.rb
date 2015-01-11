require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_many :cars }
  it { should have_many(:records).through(:cars) }

  it { should respond_to :name }
end

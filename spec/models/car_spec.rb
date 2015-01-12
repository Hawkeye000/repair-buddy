require 'rails_helper'

RSpec.describe Car, :type => :model do
  it { should have_many :records }
  it { should belong_to :user }
end

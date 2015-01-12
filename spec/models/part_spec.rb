require 'rails_helper'

RSpec.describe Part, :type => :model do
  it { should have_many(:records).through(:part_records) }
end

require 'rails_helper'

RSpec.describe PartRecord, :type => :model do
  it { should belong_to :part }
  it { should belong_to :record }
end

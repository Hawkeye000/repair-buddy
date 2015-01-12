class Part < ActiveRecord::Base
  has_many :part_records
  has_many :records, through: :part_records
end

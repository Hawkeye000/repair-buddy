class Record < ActiveRecord::Base
  belongs_to :car
  has_many :part_records
  has_many :parts, through: :part_records
end

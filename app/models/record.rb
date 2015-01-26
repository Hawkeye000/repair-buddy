class Record < ActiveRecord::Base
  belongs_to :car
  has_many :part_records
  has_many :parts, through: :part_records

  validates :record_type, format: { with: /\A(Maintenance|Repair)\z/ }
end

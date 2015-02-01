class Record < ActiveRecord::Base
  belongs_to :car
  has_many :part_records
  has_many :parts, through: :part_records

  validates :record_type, format: { with: /\A(Maintenance|Repair)\z/ }
  validates :mileage, numericality: { integer_only:true, greater_than_or_equal_to:0 }
  validates :short_title, presence:true
end

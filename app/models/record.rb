class Record < ActiveRecord::Base
  belongs_to :car
  has_one :user, through: :car
  has_many :part_records
  has_many :parts, through: :part_records

  before_validation :convert_nil_cost_to_zero

  validates :record_type, format: { with: /\A(Maintenance|Repair)\z/ }
  validates :mileage, numericality: { integer_only:true, greater_than_or_equal_to:0 }
  validates :short_title, presence:true
  validates :cost, numericality: { greater_than_or_equal_to:0.0 }
  validates :date, presence:true

  def print_date
    self.date.strftime "%B %-d, %Y"
  end

  private

    def convert_nil_cost_to_zero
      self.cost = 0 if self.cost.nil?
    end
end

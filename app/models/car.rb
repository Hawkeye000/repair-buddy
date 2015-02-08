class Car < ActiveRecord::Base

  DAYS_PER = { year:365.25, month:30.4375, day:1, week:7 }

  belongs_to :user
  has_many :records

  validates :year, presence:true, format: /\A\d{4}\z/
  validates :make, presence:true
  validates :model, presence:true
  validates :trim, presence:true
  validates :edmunds_id, presence:true
  validates :user_id, presence:

  def latest_mileage
    self.records.pluck(:mileage).sort.last
  end

  def mileage_rate(interval = :year)
    miles_dates = self.records.pluck(:mileage, :date).to_h
    max_miles, min_miles = miles_dates.keys.max, miles_dates.keys.min
    miles_delta = max_miles - min_miles
    date_delta = (miles_dates[max_miles] - miles_dates[min_miles]).to_f #in days
    miles_delta/date_delta * DAYS_PER[interval]
  end

end

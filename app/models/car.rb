class Car < ActiveRecord::Base

  belongs_to :user
  has_many :records

  validates :year, presence:true, format: /\A\d{4}\z/
  validates :make, presence:true
  validates :model, presence:true
  validates :trim, presence:true
  validates :edmunds_id, presence:true
  validates :user_id, presence:true

end

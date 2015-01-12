class Car < ActiveRecord::Base

  belongs_to :user
  has_many :records

  validates :year, presence:true
  validates :make, presence:true
  validates :model, presence:true
  validates :trim, presence:true
  validates :edmunds_id, presence:true

end

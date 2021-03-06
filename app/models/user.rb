class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :cars
  has_many :records, through: :cars

  validates :name, presence:true, format: /\A[A-Z][a-z]* [A-Z][a-z]*/
end

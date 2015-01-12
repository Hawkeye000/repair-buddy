class PartRecord < ActiveRecord::Base
  belongs_to :part
  belongs_to :record
end

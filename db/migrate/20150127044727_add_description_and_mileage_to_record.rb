class AddDescriptionAndMileageToRecord < ActiveRecord::Migration
  def change
    add_column :records, :description, :text
    add_column :records, :mileage, :integer
  end
end

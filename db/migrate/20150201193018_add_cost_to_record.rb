class AddCostToRecord < ActiveRecord::Migration
  def change
    add_column :records, :cost, :decimal
  end
end

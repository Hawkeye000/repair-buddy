class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :record_type
      t.integer :user_id
      t.integer :car_id

      t.timestamps
    end
  end
end

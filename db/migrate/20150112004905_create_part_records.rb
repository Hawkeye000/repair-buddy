class CreatePartRecords < ActiveRecord::Migration
  def change
    create_table :part_records do |t|
      t.integer :part_id
      t.integer :record_id

      t.timestamps
    end
  end
end

class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :edmunds_id
      t.string :make
      t.string :model
      t.integer :year
      t.string :trim

      t.timestamps
    end
  end
end

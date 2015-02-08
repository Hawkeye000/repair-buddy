class AddPhotoUrlAndEngineCodeAndTransmissionTypeAndModelYearIdToCar < ActiveRecord::Migration
  def change
    add_column :cars, :photo_url, :string
    add_column :cars, :engine_code, :string
    add_column :cars, :transmission_type, :string
    add_column :cars, :model_year_id, :integer
  end
end

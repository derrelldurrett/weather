class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|
      t.integer :zipcode
      t.text :data

      t.timestamps
    end
  end
end

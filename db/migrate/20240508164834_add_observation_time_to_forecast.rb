class AddObservationTimeToForecast < ActiveRecord::Migration[7.1]
  def change
    add_column :forecasts, :observed_at, :datetime
  end
end

class AddCachedToForecast < ActiveRecord::Migration[7.1]
  def change
    add_column :forecasts, :cached, :boolean, default: false, null: false
  end
end

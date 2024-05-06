require 'rails_helper'
require_relative '../../lib/common_test_helpers/mocks_helper'
include MocksHelper

RSpec.describe Forecast, type: :model do
  let(:forecast) {
    Forecast.create!(
      zipcode: 95014,
      data: initial_forecast_data
    )
  }

  it "has a zipcode" do
    expect(forecast.zipcode).to_not be_nil
    expect(forecast.zipcode).to eq(95014)
  end

  it "has forecast data" do
    expect(forecast.data).to_not be_nil
    expect(forecast.data).to be_a String
    expect(forecast.data).to match(initial_forecast_data)
  end
end

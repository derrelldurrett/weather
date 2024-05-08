require 'rails_helper'
require_relative '../../lib/common_test_helpers/mocks_helper'
include MocksHelper

RSpec.describe Forecast, type: :model do
  before do
    Timecop.freeze initial_observation_time
  end

  let(:forecast) {
    Forecast.create!(
      zipcode: 95014,
      data: initial_forecast_data,
      observed_at: Time.now
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

  it "has the observed time" do
    expect(forecast.observed_at).to_not be_nil
    expect(forecast.observed_at).to be_a Time
    expect(forecast.observed_at).to match(initial_observation_time)
  end

  after do
    Timecop.return
  end
end

require 'rails_helper'
require_relative '../../../lib/common_test_helpers/mocks_helper'
include MocksHelper

RSpec.describe "forecasts/show", type: :view do
  before(:each) do
    assign(:forecast, Forecast.create!(
      zipcode: 95014,
      data: forecast_data
    ))
    assign(:current_conditions, JSON.parse(forecast_data)['current_conditions'])
    assign(:future, JSON.parse(forecast_data)['forecast'])
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Current conditions for 95014/)
    expect(rendered).to match(/Mostly Clear/)
    expect(rendered).to match(/<strong>Temperature:<\/strong> 70&deg;F/)
  end
end

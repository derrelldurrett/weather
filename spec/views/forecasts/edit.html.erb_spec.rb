require 'rails_helper'
require_relative '../../../lib/common_test_helpers/mocks_helper'
include MocksHelper

RSpec.describe "forecasts/edit", type: :view do
  let(:forecast) {
    Forecast.create!(
      zipcode: 95014,
      data: forecast_data
    )
  }

  before(:each) do
    assign(:forecast, forecast)
  end

  it "renders the edit forecast form" do
    render

    assert_select "form[action=?][method=?]", forecast_path(forecast), "post" do

      assert_select "input[name=?]", "commit"
      assert_select "textarea[name=?]", "forecast[address]"
    end
  end
end

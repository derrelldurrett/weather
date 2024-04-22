require 'rails_helper'

RSpec.describe "forecasts/edit", type: :view do
  let(:forecast) {
    Forecast.create!(
      zipcode: 1,
      data: "MyText"
    )
  }

  before(:each) do
    assign(:forecast, forecast)
  end

  it "renders the edit forecast form" do
    render

    assert_select "form[action=?][method=?]", forecast_path(forecast), "post" do

      assert_select "input[name=?]", "forecast[address]"
    end
  end
end

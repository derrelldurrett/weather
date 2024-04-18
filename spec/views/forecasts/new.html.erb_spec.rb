require 'rails_helper'

RSpec.describe "forecasts/new", type: :view do
  before(:each) do
    assign(:forecast, Forecast.new(
      zipcode: 1,
      data: "MyText"
    ))
  end

  it "renders new forecast form" do
    render

    assert_select "form[action=?][method=?]", forecasts_path, "post" do

      assert_select "input[name=?]", "forecast[zipcode]"

      assert_select "textarea[name=?]", "forecast[data]"
    end
  end
end

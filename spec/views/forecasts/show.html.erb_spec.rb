require 'rails_helper'

RSpec.describe "forecasts/show", type: :view do
  before(:each) do
    assign(:forecast, Forecast.create!(
      zipcode: 2,
      data: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
  end
end

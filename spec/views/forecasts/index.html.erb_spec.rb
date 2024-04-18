require 'rails_helper'

RSpec.describe "forecasts/index", type: :view do
  before(:each) do
    assign(:forecasts, [
      Forecast.create!(
        zipcode: 2,
        data: "MyText"
      ),
      Forecast.create!(
        zipcode: 2,
        data: "MyText"
      )
    ])
  end

  it "renders a list of forecasts" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end

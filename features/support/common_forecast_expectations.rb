# frozen_string_literal: true

module CommonForecastExpectations
  def cached_forecast_expectations
    expect(page).to have_text('Mostly Clear')
    expect(page).to have_text('70°F')
    expect(page).to have_text('0%')
  end

  def refreshed_forecast_expectations

  end
end

World(CommonForecastExpectations)
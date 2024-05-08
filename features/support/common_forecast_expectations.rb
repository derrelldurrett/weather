# frozen_string_literal: true

module CommonForecastExpectations
  def initial_observations
    expect(page).to have_text('Current conditions for 95014')
    expect(page).to have_text('Mostly Clear')
    expect(page).to have_text('70°F')
    expect(page).to have_text('3 mph')
  end

  def cached_observations
    expect(page).to have_text('From 28 minutes ago')
    initial_observations
  end

  def refreshed_observations
    expect(page).to have_text('Current conditions for 95014')
    expect(page).to have_text('Mostly Clear')
    expect(page).to have_text('69°F')
    expect(page).to have_text('2 mph')
  end

  def cached_forecast_expectations
    within '#SaturdayNight12' do
      expect(page).to have_text('Mostly Clear')
      expect(page).to have_text('47°F')
      expect(page).to have_text('0%')
    end
  end

  alias initial_forecast_expectations cached_forecast_expectations

  def refreshed_forecast_expectations
    within '#SaturdayNight12' do
      expect(page).to have_text('Partly Cloudy')
      expect(page).to have_text('49°F')
      expect(page).to have_text('0%')
    end
  end
end

World(CommonForecastExpectations)
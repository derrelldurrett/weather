# frozen_string_literal: true
MOCKS_DIR = Rails.root.join('lib', 'common_test_helpers', 'data')

module MocksHelper
  def build_response_from(status, mock_response)
    { status: status, body: load_json_file(mock_response) }
  end

  def load_json_file(file_name)
    File.open(MOCKS_DIR.join(file_name).to_s).readlines.map(&:chomp).join.to_s
  end

  def self.assign(name, &block)
    define_method(name, &block)
  end

  assign(:mocks_dir) { Rails.root.join('features', 'support', 'data') }
  assign(:maps_response_file) { 'maps.googleapis.com.json' }
  assign(:maps_response) { build_response_from(200, maps_response_file) }
  assign(:gridpoints_response_file) { '37.3294,-122.0084.geojson' }
  assign(:gridpoints_response) { build_response_from(200, gridpoints_response_file) }
  assign(:forecast_response_file) { 'forecast.geojson' }
  assign(:forecast_response) { build_response_from(200, forecast_response_file) }
  assign(:stations_response_file) { 'stations.geojson' }
  assign(:stations_response) { build_response_from(200, stations_response_file) }
  assign(:observations_response_file) { 'latest.geojson' }
  assign(:observations_response) { build_response_from(200, observations_response_file) }
  assign(:forecast_data_file) { '95014_forecast_data.json' }
  assign(:forecast_data) { load_json_file(forecast_data_file) }
end

def load_stubs_of_external_calls
  # mock maps.googleapi.com to return lat/long for an address
  stub_request(:get, 'https://maps.googleapis.com/maps/api/geocode/json?address=1 Apple Park Way%2C Cupertino%2C California&key=not_a_real_key')
    .to_return(maps_response)

  # mock maps.googleapi.com to return lat/long for a zipcode
  stub_request(:get, 'https://maps.googleapis.com/maps/api/geocode/json?address=95014&key=not_a_real_key')
    .to_return(maps_response)

  # mock call to weather.gov to get the weather.gov grid point containing the lat/long
  stub_request(:get, 'https://api.weather.gov/points/37.3294,-122.0084')
    .to_return(gridpoints_response)

  # mock call to weather.gov to get the observation stations for the grid point
  stub_request(:get, 'https://api.weather.gov/gridpoints/MTR/95,83/stations')
    .to_return(stations_response)

  # mock call to weather.gov to get the latest observation from the station
  stub_request(:get, 'https://api.weather.gov/stations/KSJC/observations/latest')
    .to_return(observations_response)

  # mock call to weather.gov to get the forecast for the grid points
  stub_request(:get, 'https://api.weather.gov/gridpoints/MTR/95,83/forecast')
    .to_return(forecast_response)
  # mock maps.googleapi.com to return lat/long for an address
  stub_request(:get, 'https://maps.googleapis.com/maps/api/geocode/json?address=1 Apple Park Way%2C Cupertino%2C California&key=not_a_real_key')
    .to_return(maps_response)

  # mock call to weather.gov to get the weather.gov grid point containing the lat/long
  stub_request(:get, 'https://api.weather.gov/points/37.3294,-122.0084')
    .to_return(gridpoints_response)

  # mock call to weather.gov to get the observation stations for the grid point
  stub_request(:get, 'https://api.weather.gov/gridpoints/MTR/95,83/stations')
    .to_return(stations_response)

  # mock call to weather.gov to get the latest observation from the station
  stub_request(:get, 'https://api.weather.gov/stations/KSJC/observations/latest')
    .to_return(observations_response)

  # mock call to weather.gov to get the forecast for the grid points
  stub_request(:get, 'https://api.weather.gov/gridpoints/MTR/95,83/forecast')
    .to_return(forecast_response)
end
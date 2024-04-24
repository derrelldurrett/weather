# frozen_string_literal: true

module ForecastRetriever
  extend ActiveSupport::Concern
  MAPS_ROOT_URL = 'https://maps.googleapis.com/maps/api/geocode/json?'
  FORECAST_START_URL = 'https://api.weather.gov/points/'
  WEATHER_GOV_HEADERS = { 'Accept' => 'application/ld+json; charset=UTF-8',
                          'User-Agent' => 'tek-systems-application-app, derrelldurrett@gmail.com' }
  KEY = ['&key=', ENV.fetch('GOOGLE_MAPS_API_KEY')]
  KM_IN_MILES = 0.621371192

  included do
    def retrieve_forecast(params)
      lat_long_zip = look_up_location(params[:address])
      forecast = Forecast.find_by(zipcode: lat_long_zip.fetch(:zip))
      if forecast.nil?
        forecast = Forecast.new
        build_forecast(lat_long_zip, forecast)
      elsif forecast.updated_at.before?(30.minutes.ago)
        build_forecast(lat_long_zip, forecast)
      else
        forecast.cached = true
      end
      forecast
    end
  end

  private

  def build_forecast(lat_long_zip, forecast)
    forecast_data = look_up_forecast(lat_long_zip)
    forecast.zipcode = lat_long_zip.fetch(:zip)
    forecast.data = forecast_data.to_json
  end

  def look_up_forecast(lat_long_zip)
    observation_stations_url, station_reference = get_observation_stations(lat_long_zip)
    observation_root_url = get_observations_root(observation_stations_url)
    {
      current_conditions: get_observation(observation_root_url),
      forecast: get_forecast_data(station_reference)
    }
  end

  def get_forecast_data(station_reference)
    url = URI(station_reference.dig('properties', 'forecast'))
    forecast_result = get_with_retry(url, WEATHER_GOV_HEADERS)
    build_forecast_data(forecast_result.dig('properties', 'periods'))
  end

  def get_observation(observation_root_url)
    url = URI([observation_root_url, 'observations/latest'].join('/'))
    observation = get_with_retry(url, WEATHER_GOV_HEADERS)
    build_observation(observation.fetch('properties'))
  end

  def get_observations_root(observation_stations_url)
    url = URI(observation_stations_url)
    observation_stations = get_with_retry(url, WEATHER_GOV_HEADERS)
    observation_stations.dig('observationStations', 0)
  end

  def get_observation_stations(lat_long_zip)
    points = [lat_long_zip.fetch(:latitude).round(4), lat_long_zip.fetch(:longitude).round(4)].join(',')
    url = URI([FORECAST_START_URL, points].join(''))
    station_reference = get_with_retry(url, WEATHER_GOV_HEADERS)
    observation_stations_url = station_reference.dig('properties', 'observationStations')
    [observation_stations_url, station_reference]
  end

  def look_up_location(address)
    url = URI([MAPS_ROOT_URL, 'address=', ERB::Util.url_encode(address), KEY].flatten.join(''))
    location = get_with_retry(url)
    if location.fetch('results').length > 1
      raise NotSpecificLocationError.new(location.fetch('results'))
    elsif location.fetch('status') == 'ZERO_RESULTS'
      raise NotALocationError.new('No results for that location')
    end
    lat_long = extract_lat_long(location)
    zip = extract_zip(location)
    { latitude: lat_long['lat'], longitude: lat_long['lng'], zip: zip }
  end

  def extract_lat_long(location)
    location.dig('results', 0, 'geometry', 'location')
  end

  def extract_zip(location)
    location.dig('results', 0, 'address_components').filter { |c| c.fetch('types') == ['postal_code'] }.dig(0, 'long_name')
  end

  def build_forecast_data(forecast_periods)
    forecast_periods.map do |period|
      {
        identifier: "#{period['name'].gsub("\s",'')}#{period['number']}",
        name: period['name'],
        is_daytime: period['isDaytime'],
        temperature: period['temperature'],
        wind_speed: period['windSpeed'],
        wind_direction: period['windDirection'],
        chance_of_precipitation: precipitation(period.dig('probabilityOfPrecipitation', 'value')),
        icon_url: period['icon'],
        text: period['shortForecast'],
      }
    end
  end

  def precipitation(precip_chance)
    precip_chance.nil? ? 0 : precip_chance
  end

  def build_observation(observation_data)
    {
      conditions: observation_data.fetch('textDescription'),
      icon: observation_data.fetch('icon'),
      temperature: extract_temperature(observation_data.fetch('temperature')),
      wind_speed: extract_wind_speed(observation_data.fetch('windSpeed')),
      wind_direction: extract_wind_direction(observation_data.fetch('windDirection'))
    }
  end

  def extract_temperature(temperature_data)
    t = temperature_data.fetch('value')
    return '-' if t.nil?

    temperature_data.fetch('unitCode') == 'wmoUnit:degC' ? convert_c_to_f(t) : t
  end

  def extract_wind_speed(wind_speed_data)
    s = wind_speed_data.fetch('value')
    return '-' if s.nil?

    wind_speed_data.fetch('unitCode') == 'wmoUnit:km_h-1' ? convert_to_mph(s) : s
  end

  def extract_wind_direction(wind_direction_data)
    d = wind_direction_data.fetch('value')
    return '-' if d.nil?

    wind_direction_data.fetch('unitCode') == 'wmoUnit:degree_(angle)' ? convert_to_cardinal(d) : d
  end

  def convert_c_to_f(celsius)
    (celsius * 1.8 + 32.0).round
  end

  def convert_to_mph(kph)
    (kph * KM_IN_MILES).round
  end

  def convert_to_cardinal(angle)
    angle %= 360 # Normalize angle to be within [0, 360)
    directions = %w[N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW]
    index = ((angle + 11.25) % 360) / 22.5
    directions[index.floor]
  end
end

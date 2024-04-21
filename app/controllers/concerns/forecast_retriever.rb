# frozen_string_literal: true

module ForecastRetriever
  extend ActiveSupport::Concern
  MAPS_ROOT_URL = 'https://maps.googleapis.com/maps/api/geocode/json?'
  FORECAST_ROOT_URL = 'https://api.weather.gov/points/'
  WEATHER_GOV_HEADERS = { 'Accept' => 'application/ld+json; charset=UTF-8',
                          'User-Agent' => 'tek-systems-application-app, derrelldurrett@gmail.com' }
  KEY = ['&key=', ENV.fetch('GOOGLE_MAPS_API_KEY')]
  KM_IN_MILES = 0.621371192

  included do
    def retrieve_forecast(params)
      lat_long_zip = look_up_location(params[:address])
      forecast = Forecast.find_by(zipcode: lat_long_zip.fetch(:zip))
      if forecast.nil? or forecast.created_at.before?(30.minutes.ago)
        forecast_data = look_up_forecast(lat_long_zip)
        forecast = Forecast.new
        forecast.zipcode = lat_long_zip.fetch(:zip)
        forecast.data = forecast_data
        forecast.save!
      end
      forecast
    end
  end

  private
  def look_up_forecast(lat_long_zip)
    points = [lat_long_zip.fetch(:latitude).round(4), lat_long_zip.fetch(:longitude).round(4)].join(',')
    url = URI([FORECAST_ROOT_URL, points].join(''))
    puts "lat/lng to station: "+url.hostname
    intermediate = JSON.parse Net::HTTP.get(url, WEATHER_GOV_HEADERS)
    #check response and retry if status not 200...
    observation_stations_url = intermediate.dig('properties', 'observationStations')
    url = URI(observation_stations_url)
    puts "observation stations: "+url.hostname
    observation_stations = JSON.parse Net::HTTP.get(url, WEATHER_GOV_HEADERS)
    #check response and retry if status not 200...
    observation_root_url = observation_stations.dig('observationStations', 0)
    url = URI([observation_root_url, 'observations/latest'].join('/'))
    puts "latest observation: "+url.hostname
    observation = JSON.parse Net::HTTP.get(url, WEATHER_GOV_HEADERS)
    # check response and retry if status not 200
    #forecast_data =
    build_observation(observation.fetch('properties'))
    #forecast_url = intermediate.dig('properties', 'forecast')
  end

  def look_up_location(address)
    url = URI([MAPS_ROOT_URL, 'address=', ERB::Util.url_encode(address), KEY].flatten.join(''))
    location = JSON.parse Net::HTTP.get(url)
    # check response and retry if status not 200
    raise NotSpecificLocationError.new(location) if location.fetch('results').length > 1
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
    temperature_data.fetch('unitCode') == 'wmoUnit:degC' ? convert_c_to_f(t) : t
  end

  def extract_wind_speed(wind_speed_data)
    s = wind_speed_data.fetch('value')
    wind_speed_data.fetch('unitCode') == 'wmoUnit:km_h-1' ? convert_to_mph(s) : s
  end

  def convert_c_to_f(celsius)
    (celsius * 1.8 + 32.0).round
  end

  def convert_to_mph(kph)
    (kph * KM_IN_MILES).round
  end
end

# frozen_string_literal: true

module ForecastRetriever
  extend ActiveSupport::Concern
  MAPS_ROOT_URL = 'https://maps.googleapis.com/maps/api/geocode/json?'
  FORECAST_ROOT_URL = 'https://api.weather.gov/points/'
  WEATHER_GOV_HEADERS = { 'Accept' => 'application/ld+json; charset=UTF-8',
                          'User-Agent' => 'tek-systems-application-app, derrelldurrett@gmail.com' }
  KEY = ['&key=', ENV.fetch('GOOGLE_MAPS_API_KEY')]

  included do
    def retrieve_forecast(params)
      lat_long_zip = look_up_location(params[:address])
      forecast_data = look_up_forecast(lat_long_zip)
    end
  end

  private
  def look_up_forecast(lat_long_zip)

    points = [lat_long_zip.fetch(:latitude), lat_long_zip.fetch(:longitude)].join(',')
    url = URI([FORECAST_ROOT_URL, points])
    intermediate = JSON.parse Net::HTTP.get(url, WEATHER_GOV_HEADERS)
    #check response and retry if not status 200...
    forecast_url = intermediate.dig('properties', 'forecast')
    observations_root_url = intermediate.dig('properties', 'observationStations', 0)

  end

  def look_up_location(address)
    url = URI([MAPS_ROOT_URL, 'address=', ERB::Util.url_encode(address), KEY].flatten.join(''))
    location = JSON.parse Net::HTTP.get(url)
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
end

class ForecastsController < ApplicationController
  include ForecastRetriever
  include HttpAutoRetry
  before_action :set_forecast, only: %i[ show ]

  rescue_from NotSpecificLocationError, with: :not_a_specific_address
  rescue_from HttpRequestError, with: :http_request_error
  rescue_from NotALocationError, with: :not_a_location
  rescue_from StandardError, with: :http_request_error

  def not_a_location(exception = nil)
    flash[:notice] = "Location not found: #{exception.message}"
    redirect_to '/'
  end

  def not_a_specific_address(exception)
    flash[:notice] = "This address is not specific enough.\n#{exception.message}"
    redirect_to '/'
  end

  def http_request_error(exception)
    flash[:notice] = "Bad request - giving up:\n#{exception.message}"
    redirect_to '/'
  end

  # GET /forecasts/1 or /forecasts/1.json
  def show
    data = JSON.parse(@forecast.data)
    @current_conditions = data.fetch('current_conditions')
    @future = data.fetch('forecast')
  end

  # GET /forecasts/new
  def new
    @forecast = Forecast.new
  end

  # POST /forecasts or /forecasts.json
  def create
    @forecast = retrieve_forecast(forecast_params)

    respond_to do |format|
      if @forecast.save
        format.html { redirect_to forecast_url(@forecast) }
        format.json { render :show, status: :created, location: @forecast }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_forecast
      @forecast = Forecast.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def forecast_params
      params.require(:forecast).permit(:address)
    end
end

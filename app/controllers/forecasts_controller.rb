class ForecastsController < ApplicationController
  include ForecastRetriever
  before_action :set_forecast, only: %i[ show ]

  rescue_from NotSpecificLocationError, :with => :not_a_specific_address

  def not_a_specific_address(exception)
    flash[:notice] = "This address is not specific enough.\n#{exception.message}"
    redirect_to "/"
  end


  # GET /forecasts/1 or /forecasts/1.json
  def show
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

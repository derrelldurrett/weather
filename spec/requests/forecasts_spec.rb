require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/forecasts", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Forecast. As you add validations to Forecast, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Forecast.create! valid_attributes
      get forecasts_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      forecast = Forecast.create! valid_attributes
      get forecast_url(forecast)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_forecast_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      forecast = Forecast.create! valid_attributes
      get edit_forecast_url(forecast)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Forecast" do
        expect {
          post forecasts_url, params: { forecast: valid_attributes }
        }.to change(Forecast, :count).by(1)
      end

      it "redirects to the created forecast" do
        post forecasts_url, params: { forecast: valid_attributes }
        expect(response).to redirect_to(forecast_url(Forecast.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Forecast" do
        expect {
          post forecasts_url, params: { forecast: invalid_attributes }
        }.to change(Forecast, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post forecasts_url, params: { forecast: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested forecast" do
        forecast = Forecast.create! valid_attributes
        patch forecast_url(forecast), params: { forecast: new_attributes }
        forecast.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the forecast" do
        forecast = Forecast.create! valid_attributes
        patch forecast_url(forecast), params: { forecast: new_attributes }
        forecast.reload
        expect(response).to redirect_to(forecast_url(forecast))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        forecast = Forecast.create! valid_attributes
        patch forecast_url(forecast), params: { forecast: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested forecast" do
      forecast = Forecast.create! valid_attributes
      expect {
        delete forecast_url(forecast)
      }.to change(Forecast, :count).by(-1)
    end

    it "redirects to the forecasts list" do
      forecast = Forecast.create! valid_attributes
      delete forecast_url(forecast)
      expect(response).to redirect_to(forecasts_url)
    end
  end
end
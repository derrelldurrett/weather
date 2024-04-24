require "rails_helper"

RSpec.describe ForecastsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/").to route_to("forecasts#new")
    end

    it "routes to #show" do
      expect(get: "/forecasts/1").to route_to("forecasts#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/forecasts").to route_to("forecasts#create")
    end
  end
end

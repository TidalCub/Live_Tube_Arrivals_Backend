require "rails_helper"

RSpec.describe Api::V1::StationsController, type: :request do
  describe "GET #LiveDeparturesPredictions" do
    let(:headers) { { "ACCEPT" => "application/json" } }

    context "with invalid location" do
      let(:params) { { lat: "", lon: "" } }
      subject(:call) { get "/api/v1/stations/live_departures_predictions", params: params, headers: headers }

      it "returns 422" do
        call
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error message" do
        call
        expect(response.parsed_body).to eq("error" => "Invalid latitute and longitude")
      end
    end

    context "with valid location" do
      context "when its nears a station" do
        
      end
    end
  end
  
end

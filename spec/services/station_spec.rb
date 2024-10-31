require "rails_helper"
require "vcr"

RSpec.describe Station do
  describe "#initialize" do
    context "with valid location" do
      it "find the nearest station" do
        VCR.use_cassette("station_by_location") do
          station = Station.new(latitude: 51.5412, longitude: -0.0033)
          expect(station.station).to match_array(
              naptan_id: "940GZZLUSTD",
              name: "Stratford Underground Station",
              latitude: 51.541806,
              longitude: -0.003458,
              lines: [
                { id: "central", line_name: "Central", uri: "/Line/central" },
                { id: "jubilee", line_name: "Jubilee", uri: "/Line/jubilee" }
              ]
          )
        end
      end

      context "where there is more than one station" do
        it "only returns the closest station" do
          VCR.use_cassette("multiple_station_by_location") do
            station = Station.new(latitude: 51.5029, longitude: -0.1134)
            expect(station.station).to match_array(
                naptan_id: "940GZZLUWLO",
                name: "Waterloo Underground Station",
                latitude: 51.503299,
                longitude: -0.11478,
                lines: [
                  { id: "bakerloo", line_name: "Bakerloo", uri: "/Line/bakerloo" },
                  { id: "jubilee", line_name: "Jubilee", uri: "/Line/jubilee" },
                  { id: "northern", line_name: "Northern", uri: "/Line/northern" },
                  { id: "waterloo-city", line_name: "Waterloo & City", uri: "/Line/waterloo-city" }
                ]
            )
          end
        end
      end
    end
  end

  describe "#live_departures_predictions" do
    context "with valid station" do
      let(:station) { Station.new(latitude: 51.5412, longitude: -0.0033) }

      before do
        VCR.use_cassette("station_by_location") do
          station
        end
      end

      it "returns the live departures predictions" do
        VCR.use_cassette("live_departures_predictions") do
          arrivals = station.live_departures_predictions
          expect(arrivals["central"].first).to match_array(
            { destination_name: "West Ruislip Underground Station", destination_naptan_id: "940GZZLUWRP", direction: "westbound",
            platform: "3", time_to_station: 19, expected_arrival: "2024-10-31T08:54:25Z" }
          )
        end
      end
    end
  end
end

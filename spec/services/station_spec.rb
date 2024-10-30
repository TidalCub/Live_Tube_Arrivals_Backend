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
              longitude: -0.003458
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
                longitude: -0.11478
            )
          end
        end
      end
    end
  end
end

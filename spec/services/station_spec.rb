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
    end
  end
end

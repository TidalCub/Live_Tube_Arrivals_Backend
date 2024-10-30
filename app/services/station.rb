

class Station
  include HTTParty
  base_uri "https://api.tfl.gov.uk/StopPoint"

  attr_reader :station

  def initialize(naptan_id: nil, longitude: nil, latitude: nil, name: nil)
    unless longitude.nil? || latitude.nil?
      @station = station_by_location(longitude, latitude)
    end
  end

  private

  def station_by_location(longitude, latitude, stopTypes = "NaptanMetroStation")
    response = self.class.get("/?lat=#{latitude}&lon=#{longitude}&stopTypes=#{stopTypes}")
    response["stopPoints"].map do |station|
      next unless station["modes"].include?("tube")
      {
        naptan_id: station["naptanId"],
        name: station["commonName"],
        latitude: station["lat"],
        longitude: station["lon"]
      }
    end.compact.first
  end
end

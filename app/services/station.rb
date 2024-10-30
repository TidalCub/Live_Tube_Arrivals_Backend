

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
    stations = response["stopPoints"].map do |stop_point|
      next unless stop_point["modes"].include?("tube")
      formate_stop_point(stop_point)
    end.compact

    if stations.count == 1
      stations.first
    else
      closest_station(stations, longitude, latitude)
    end
  end

  def closest_station(stations, longitude, latitude)
    stations.min_by do |station|
      haversine_distance([ latitude, longitude ], [ station[:latitude], station[:longitude] ])
    end
  end

  def formate_stop_point(stop_point)
    {
        naptan_id: stop_point["naptanId"],
        name: stop_point["commonName"],
        latitude: stop_point["lat"],
        longitude: stop_point["lon"]
      }
  end
end

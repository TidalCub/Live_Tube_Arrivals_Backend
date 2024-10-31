

class Station
  include HTTParty
  base_uri "https://api.tfl.gov.uk/StopPoint"

  attr_reader :station

  def initialize(naptan_id: nil, longitude: nil, latitude: nil, name: nil)
    unless longitude.nil? || latitude.nil?
      @station = station_by_location(longitude, latitude)
    end
  end

  def live_departures_predictions
    arrivals = self.class.get("/#{@station[:naptan_id]}/arrivals")
    formate_arrivals(arrivals)
  end

  private

  def station_by_location(longitude, latitude, stopTypes = "NaptanMetroStation")
    response = self.class.get("/?lat=#{latitude}&lon=#{longitude}&stopTypes=#{stopTypes}&radius=400")
    if response["stopPoints"].empty?
      return { error: "No station found" }
    end
    stations = response["stopPoints"].map do |stop_point|
      next unless stop_point["modes"].include?("tube")
      formate_stop_point(stop_point)
    end.compact

    stations.first
  end

  def formate_stop_point(stop_point)
    {
        naptan_id: stop_point["naptanId"],
        name: station_name_formater(stop_point["commonName"]),
        latitude: stop_point["lat"],
        longitude: stop_point["lon"],
        lines:
          stop_point["lines"].map do |line|
            {
              id: line["id"],
              line_name: line["name"],
              uri: line["uri"]
            }
          end
      }
  end

  def formate_arrivals(arrivals)
    lines = @station[:lines].each_with_object({}) do |line, hash|
      hash[line[:id]] = []
    end

    arrivals.each do |arrival|
      if lines.key?(arrival["lineId"])
        lines[arrival["lineId"]] << {
          destination_name: station_name_formater(arrival["destinationName"]),
          destination_naptan_id: arrival["destinationNaptanId"],
          direction: direction_formater(arrival["platformName"]),
          platform: platform_formater(arrival["platformName"]),
          time_to_station: arrival["timeToStation"],
          expected_arrival: arrival["expectedArrival"]
        }
      end
    end

    lines.each do |line_id, line_arrivals|
      lines[line_id] = line_arrivals.sort_by { |arrival| arrival[:time_to_station] }
    end

    lines
  end

  def direction_formater(platform_name)
    valid_directions = [ "westbound", "eastbound", "southbound", "northbound" ]
    direction = platform_name.split("-").first.strip.downcase
    valid_directions.include?(direction) ? direction : "unknown"
  end

  def platform_formater(platform_name)
    platform_name[/platform (\d+)/i, 1]
  end

  def station_name_formater(station_name)
    station_name.gsub("Underground Station", "").strip
  end
end

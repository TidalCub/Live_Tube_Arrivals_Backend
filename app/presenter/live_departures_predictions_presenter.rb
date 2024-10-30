
class LiveDeparturesPredictionsPresenter
  def initialize(latitude = nil, longitude = nil)
    @latitude = latitude
    @longitude = longitude
  end

  def as_json
    station = Station.new(latitude: @latitude, longitude: @longitude)

    if station.station[:error]
      { error: station.station[:error] }
    else
      {
        station: station.station,
        # status: station.station[:lines].map { |line| Line.new.status(line[:line_id]) },
        arrivals: station.live_departures_predictions
      }
    end
  end
end

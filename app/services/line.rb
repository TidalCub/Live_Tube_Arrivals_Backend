class Line
  include HTTParty
  base_uri "https://api.tfl.gov.uk/Line"

  def status (line)
    response = self.class.get("/#{line}/Status")
    {
      severity_descriptor: response.first["lineStatuses"].first["statusSeverityDescription"],
      severity_level: response.first["lineStatuses"].first["statusSeverity"]
    }
  end
end

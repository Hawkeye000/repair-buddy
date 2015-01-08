module Edmunds

  BASE_URI = "https://api.edmunds.com"
  VEHICLE = "/api/vehicle/v2"

  def self.list_of_auto_makes(options)
    RestClient.get(BASE_URI + VEHICLE + "/makes", options)
  end

end

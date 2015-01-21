module Edmunds

  BASE_URI = "https://api.edmunds.com"
  VEHICLE = "/api/vehicle/v2"

  def self.list_of_auto_makes(options)
    options[:params][:year] = "1800" if options[:params][:year] == ""
    raw_makes = RestClient.get(BASE_URI + VEHICLE + "/makes", options)
    JSON.parse(raw_makes)["makes"].map { |x| x["name"] }
  end

  def self.list_of_auto_models(make_name = "", options)
    raw_models = RestClient.get(BASE_URI + VEHICLE + "/#{make_name.gsub(' ', '_').gsub('-', '_').underscore}", options)
    JSON.parse(raw_models)["models"].map { |x| x["name"] }
  end

  def self.list_of_auto_styles(make_name = "", model_name = "", year = "", options)
    raw_styles = RestClient.get(BASE_URI + VEHICLE +
        "/#{make_name.gsub(' ', '_').gsub('-', '_').underscore}" +
        "/#{model_name.gsub(' ', '_').gsub('-', '_').underscore}" +
        "/#{year}", options)
    styles = JSON.parse(raw_styles)["styles"]
    styles.map { |x| [x["id"], x["name"]] }.to_h unless styles.nil?
  end

  def self.car_lookup_by_vin(vin="", options)
    raw_car_data = RestClient.get(BASE_URI + VEHICLE + "/vins/#{vin}", options)
    car_data = JSON.parse(raw_car_data)
    car_data_h = {
      :make => car_data["make"]["name"],
      :model => car_data["model"]["name"],
      :year => car_data["years"].first["year"],
      :trim => car_data["years"].first["styles"].first["name"],
      :edmunds_id => car_data["years"].first["styles"].first["id"]
    }
  end

end

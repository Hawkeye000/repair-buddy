module Edmunds

  BASE_URI = "https://api.edmunds.com"
  VEHICLE = "/api/vehicle/v2"

  def self.list_of_auto_makes(options)
    options[:params][:year] = "1800" if options[:params][:year] == ""
    raw_makes = RestClient.get(BASE_URI + VEHICLE + "/makes", options)
    JSON.parse(raw_makes)["makes"].map { |x| x["name"] }
  end

  def self.list_of_auto_models(model_name, options)
    raw_models = RestClient.get(BASE_URI + VEHICLE + "/#{model_name.gsub(' ', '_').underscore}", options)
    JSON.parse(raw_models)["models"].map { |x| x["name"] }
  end

end

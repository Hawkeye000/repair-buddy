module Edmunds

  BASE_URI = "https://api.edmunds.com"
  VEHICLE_V2 = "/api/vehicle/v2"
  VEHICLE_V1 = "/api/vehicle/v1"
  PHOTO_V1 = "/v1/api/vehiclephoto/service"
  PHOTO_HOST = "http://media.ed.edmunds-media.com"

  def self.list_of_auto_makes(options)
    options[:params][:year] = "1800" if options[:params][:year] == ""
    raw_makes = RestClient.get(BASE_URI + VEHICLE_V2 + "/makes", options)
    JSON.parse(raw_makes)["makes"].map { |x| x["name"] }
  end

  def self.list_of_auto_models(make_name = "", options)
    raw_models = RestClient.get(BASE_URI + VEHICLE_V2 + "/#{make_name.gsub(' ', '_').gsub('-', '_').underscore}", options)
    JSON.parse(raw_models)["models"].map { |x| x["name"] }
  end

  def self.list_of_auto_styles(make_name = "", model_name = "", year = "", options)
    raw_styles = RestClient.get(BASE_URI + VEHICLE_V2 +
        "/#{make_name.gsub(' ', '_').gsub('-', '_').underscore}" +
        "/#{model_name.gsub(' ', '_').gsub('-', '_').underscore}" +
        "/#{year}", options)
    styles = JSON.parse(raw_styles)["styles"]
    styles.map { |x| [x["id"], x["name"]] }.to_h unless styles.nil?
  end

  def self.car_lookup_by_vin(vin="", options)
    raw_car_data = RestClient.get(BASE_URI + VEHICLE_V2 + "/vins/#{vin}", options)
    car_data = JSON.parse(raw_car_data)
    car_data_h = {
      :make => car_data["make"]["name"],
      :model => car_data["model"]["name"],
      :year => car_data["years"].first["year"],
      :trim => car_data["years"].first["styles"].first["name"],
      :edmunds_id => car_data["years"].first["styles"].first["id"]
    }
  end

  def self.auto_style_details(style_id="", options)
    # edmunds_api needs full view to get engine code and transmission type
    # this will be used for matching a style id to maintenance records
    options[:params][:view] = "full"
    raw_style_data = RestClient.get(BASE_URI + VEHICLE_V2 + "/styles/#{style_id}", options)
    style_data = JSON.parse(raw_style_data)
    style_data_h = {
      :model_year_id => style_data["year"]["id"],
      :engine_code => style_data["engine"]["code"],
      :transmission_type => style_data["transmission"]["transmissionType"]
    }
  end

  def self.auto_show_picture(view="FQ", width="500", options)
    raw_pic_data = RestClient.get(BASE_URI + PHOTO_V1 + "/findphotosbystyleid", options)
    pic_data = JSON.parse(raw_pic_data)
    pics_view = pic_data.find { |pic| pic["shotTypeAbbreviation"] == view }
    pic_url = pics_view["photoSrcs"].find { |url| (Regexp.new "_#{width}.jpg") =~ url }
    PHOTO_HOST + pic_url
  end

end

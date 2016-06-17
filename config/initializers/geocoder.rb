Geocoder.configure do |config|
  config.lookup = :google
  config.api_key = "API_KEY"
  config.timeout = 5
  config.units = :km
end
Rails.application.config.middleware.use OmniAuth::Builder do
provider :facebook, '1010053535725175','f020f9d7682a0c0f5deee8bcdb2c4853'
provider :twitter, 'WKa59cT4HUroGxaou7OqvvCLj','D04jHC6Kn1biyeNXU1FDmCBrLZvY73P5h9eVT2FRyLOz9DUKtu'
provider :github , '487bdb52a04426cce15b','8a6491055d4c54b7c2ca6827748ff7c41b576083'
provider :fitbit_oauth2, '227PKK', '27e611ad3701e49d5541cbac1c031b73', :scope => 'name'
end

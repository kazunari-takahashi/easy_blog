Rails.application.config.generators do |g|
  g.assets false
  g.helper false
  g.test_framework :rspec, view_specs: false, helper_specs: false, routing_specs: false
  g.fixture_replacement :factory_bot
  g.factory_bot suffix: "factory", dir: "spec/factories"
end

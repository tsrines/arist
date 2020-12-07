RSpec.configure do |config|
  config.before(:each, type: :system) { driven_by :rack_test }

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end

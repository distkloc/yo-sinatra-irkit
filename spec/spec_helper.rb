require 'rspec'
require 'rack/test'
require 'vcr'

require File.expand_path '../../app.rb', __FILE__

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods

  def app
    App
  end
end

RSpec.configure do |c|
  c.include RSpecMixin
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.filter_sensitive_data("<USER_NAME>") { ENV['USER_NAME'] }
  c.filter_sensitive_data("<TOKEN>") { ENV['API_KEY'] }
  c.filter_sensitive_data("<YO_API_KEY>") { ENV['YO_API_KEY'] }
  c.filter_sensitive_data("<IRKIT_CLIENT_KEY>") { ENV['IRKIT_CLIENT_KEY'] }
  c.filter_sensitive_data("<IRKIT_DEVICE_ID>") { ENV['IRKIT_DEVICE_ID'] }
end


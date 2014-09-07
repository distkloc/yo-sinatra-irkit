require 'rspec'
require 'rack/test'

require File.expand_path '../../app.rb', __FILE__

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods

  def app
    App
  end
end

RSpec.configure do |conf|
  conf.include RSpecMixin
end


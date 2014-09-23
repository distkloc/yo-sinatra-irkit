require 'bundler/setup'
require 'sinatra'
require 'faraday'
require 'yo-ruby'

module SendingYoHelper
  def yo(username)
    Yo.yo!(username)
  rescue YoUserNotFound 
    error 400
  rescue YoRateLimitExceeded
  end
end

class App < Sinatra::Base

  configure :development do
    Bundler.require :development
    register Sinatra::Reloader
  end

  helpers SendingYoHelper

  Yo.api_key = ENV['YO_API_KEY']

  before do
    error 401 unless params[:username] && params[:username].upcase == ENV['USER_NAME'].upcase
    error 401 unless params[:token] == ENV['API_KEY']
  end

  get '/on_hook' do
    @connection ||= Faraday.new(:url => 'https://api.getirkit.com')

    response = @connection.post do |req|
      req.url '/1/messages'
      req.body = {
        :clientkey => ENV['IRKIT_CLIENT_KEY'],
        :deviceid => ENV['IRKIT_DEVICE_ID'],
        :message => ENV['ON_MESSAGE']
      }
    end

    error response.status unless response.status == 200

    yo ENV['USER_NAME']
  end

end

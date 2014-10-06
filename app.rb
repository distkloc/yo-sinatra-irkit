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

module IrkitHelper
  def send(message)
    @connection ||= Faraday.new(:url => 'https://api.getirkit.com')

    response = @connection.post do |req|
      req.url '/1/messages'
      req.body = {
        :clientkey => ENV['IRKIT_CLIENT_KEY'],
        :deviceid => ENV['IRKIT_DEVICE_ID'],
        :message => message
      }
    end

    error response.status unless response.status == 200
  end
end

class App < Sinatra::Base

  configure :development do
    Bundler.require :development
    register Sinatra::Reloader
  end

  helpers SendingYoHelper
  helpers IrkitHelper

  before do
    error 401 unless params[:username] && params[:username].upcase == ENV['USER_NAME'].upcase
    error 401 unless params[:token] == ENV['API_KEY']
  end

  get '/on_hook' do
    send ENV['MESSAGE']
    Yo.api_key = ENV['YO_API_KEY']
    yo ENV['USER_NAME']
  end

end

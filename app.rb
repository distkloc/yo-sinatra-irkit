require 'bundler/setup'
require 'sinatra'
require 'faraday'
require 'yo-ruby'

class App < Sinatra::Base

  configure :development do
    Bundler.require :development
    register Sinatra::Reloader
  end

  Yo.api_key = ENV['YO_API_KEY']

  before do
    error 401 unless params[:token] == ENV['API_KEY']
  end

  after do
    begin
      Yo.yo!(ENV['USER_NAME'])
    rescue YoUserNotFound 
      error 400
    rescue YoRateLimitExceeded
    end
  end

  get '/on_hook' do
    Yo.from(params, ENV['USER_NAME']) do |link|
      @connection ||= Faraday.new(:url => 'https://api.getirkit.com')

      @connection.post do |req|
        req.url '/1/messages'
        req.body = {
          :clientkey => ENV['IRKIT_CLIENT_KEY'],
          :deviceid => ENV['IRKIT_DEVICE_ID'],
          :message => ENV['ON_MESSAGE']
        }
      end
    end
  end

end

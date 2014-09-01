require 'bundler/setup'
require 'sinatra'
require 'faraday'

class App < Sinatra::Base

  configure :development do
    Bundler.require :development
    register Sinatra::Reloader
  end

  get '/callback' do
    status 400 unless valid_token?
    status 400 unless valid_user?

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

  private
    
    def valid_token?
      params[:token] == ENV['API_KEY']
    end

    def valid_user?
      params[:username] == ENV['USER_NAME']
    end
end

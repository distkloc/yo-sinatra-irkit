require 'bundler/setup'
require 'sinatra'
require 'faraday'

class App < Sinatra::Base

  configure :development do
    Bundler.require :development
    register Sinatra::Reloader
  end

  before do
    error 401 unless params[:token] == ENV['API_KEY']
    error 401 unless params[:username] == ENV['USER_NAME'].upcase
  end

  get '/callback' do
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

require 'bundler/setup'
require 'sinatra'

class App < Sinatra::Base

  get '/callback' do
    status 400 unless params[:username]
  end

end

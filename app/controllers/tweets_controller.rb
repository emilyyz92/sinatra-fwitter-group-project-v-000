require './config/environment'
require 'sinatra/flash'

class TweetsController < ApplicationController
  get '/tweets' do
    erb :'/tweets/show'
  end
end

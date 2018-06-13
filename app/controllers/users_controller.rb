require './config/environment'
require 'sinatra/flash'

class UsersController < ApplicationController
  configure do
    enable :sessions
    set :session_secret, "secret"
    register Sinatra::Flash
  end

  get '/signup' do
    erb :'/users/signup'
  end

  post '/signup' do
    if params[:user].values.any? {|a| a == [] || a == "" || a == nil}
      flash[:message] = "Your username/password/email is invalid. Please try again."
      redirect "/signup"
    else
      User.create(params[:user])
      redirect "/tweets"
    end
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      if session[:user_id] == user.id
        redirect "/logout"
      else
        session[:user_id] = user.id
        redirect "/users/#{user.slug}"
      end
    else
      flash[:message] = "Your username/password is invalid. Please try again."
      redirect "/login"
    end
  end

  get '/logout' do
    if session[:user_id] != nil || session[:user_id] != ""
      session.clear
      flash[:message] = "You are logged out."
      redirect "/login"
    else
      redirect "/"
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    "Welcome, #{@user.name}!"
    redirect "/tweets"
  end

end

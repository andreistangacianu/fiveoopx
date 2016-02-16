class SessionsController < ApplicationController
  def new
  end

  def create
  	# Check to see if the oAuth api returns a 200 response and generates the token.
  	consumer = OAuth::Consumer.new(ENV["consumer_key"], ENV["consumer_secret"],
		      :site               => "https://api.500px.com",
		      :request_token_path => "/v1/oauth/request_token",
		      :access_token_path  => "/v1/oauth/access_token",
		      :authorize_path     => "/v1/oauth/authorize"
      )

  	session[:consumer] = consumer
  	session[:request_token] = session[:consumer].get_request_token(:oauth_callback => "http://fiveoopx.herokuapp.com/auth")

  	redirect_to session[:request_token].authorize_url
  end

  def auth
  	session[:oauth_token] = params["oauth_token"]
    	session[:oauth_verifier] = params["oauth_verifier"]

    	session[:access_token] = session[:consumer].get_access_token(session[:request_token], :oauth_token => session[:oauth_token], :oauth_verifier => session[:oauth_verifier])
  
  	redirect_to root_url
  end
end

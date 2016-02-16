class PhotosController < ApplicationController
respond_to :html, :json	

  def index
  	access_token = session[:access_token]
  	# Post Url
  	if access_token then
  		response = access_token.get('/v1/photos?feature=popular&sort_direction=desc&rpp=100&page=1')
  	else
  		redirect_to login_path and return
  	end

  	photos = JSON.parse(response.body)

  	@images = {}
  	photos["photos"].each_with_index do |photo, index|
  			@images[index] = []
  			@images[index] << photo["id"]
			@images[index] << photo["image_url"]
			@images[index] << photo["votes_count"]
  	end
  end

  def votePhoto
  	access_token = session[:access_token]

  	if access_token then
  		response = access_token.post("/v1/photos/#{params[:id]}/vote?vote=1")
  	end
  	decoded_response = JSON.parse(response.body)
  	
  	# If the vote was successful - get the updated number of votes for this photo

  	if response.code == "200"
  		flash[:success] = "Thank you for your vote!"
  		access_token = session[:access_token]
	  	photo = params[:id]
	  	if access_token then
	  		votes = access_token.get("/v1/photos/#{params[:id]}/votes")
	  	end

	  	decodedVotes = JSON.parse(votes.body)
	  	votes = decodedVotes["total_items"]
	  	flash[:success] = "Thank you for voting!"
  		redirect_to action: "index"
  	else
  		# render the error
  		flash[:danger] = "#{decoded_response["error"]}"
  		redirect_to action: "index"
  	end
  end

end

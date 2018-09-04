class LikesController < ApplicationController

  # returns json for the index page at /likes, the number of likes for game_id
  def index    
    render json: Like.count(params[:game_id])
  end

  # GET /likes/1
  def show
    like = Like.find(params[:id])
    render :json => like.as_json
  end

  # POST /likes
  def create
    Like.like_game(request.remote_ip,params[:game_id])
  end
  
  private
    def like_params
      params.require(:game_id).require(:ip)
    end
end

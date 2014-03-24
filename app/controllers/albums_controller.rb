class AlbumsController < ApplicationController
  def index
    @albums = Album.all.page params[:page]
    respond_to do |format|
      format.html
      format.json { render json: @albums }
    end
  end

  def show
    @album = Album.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @album.as_json_details }
    end
  end

  def filter_by_tag
    @albums = Album.where(tag: params[:tag]).page params[:page]
    render @albums.as_json 
  end
end
class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    redirect_to galleries_path
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
    authorize! :read, @image
    bitly = Shortly::Clients::Bitly
    bitly.apiKey  = ENV['BITLY_API_KEY_ID']
    bitly.login   = ENV['BITLY_LOGIN_USERNAME']
    @url = bitly.shorten(@image.avatar.url(:original)).url
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
    redirect_to galleries_path
  end

  # POST /images
  # POST /images.json
  def create
    @gallery = Gallery.find(params[:gallery_id])
    @image = @gallery.images.build(image_params)
    @image.user = current_user

    if @image.save
      render json: { message: "success", fileID: @image.id }, :status => 200
    else
      render json: { error: @image.errors.full_messages.join(',')}, :status => 400
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    authorize! :update, @image
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    authorize! :destroy, @image
    @gallery = Gallery.find(params[:gallery_id])
    @image = @gallery.images.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to gallery_path(@gallery), notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.require(:image).permit(:avatar)
  end
end

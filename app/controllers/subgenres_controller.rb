class SubgenresController < ApplicationController
  # GET /subgenres
  # GET /subgenres.json
  def index
    @subgenres = Subgenre.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subgenres }
    end
  end

  # GET /subgenres/1
  # GET /subgenres/1.json
  def show
    @subgenre = Subgenre.find(params[:id])
    @books = Book.where(subgenre_id: @subgenre.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subgenre }
    end
  end

  # GET /subgenres/new
  # GET /subgenres/new.json
  def new
    @subgenre = Subgenre.new
    @genres = Genre.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subgenre }
    end
  end

  # GET /subgenres/1/edit
  def edit
    @genres = Genre.all
    @subgenre = Subgenre.find(params[:id])
  end

  # POST /subgenres
  # POST /subgenres.json
  def create
    @subgenre = Subgenre.new

    @subgenre.title = params[:subgenre]['title']
    @subgenre.genre = params[:subgenre]['genre']
    @subgenre.subgenre = SubgenreUploader.new
    @subgenre.subgenre.store!(params[:subgenre]['subgenre'])

    respond_to do |format|
      if @subgenre.save
        format.html { redirect_to subgenres_path, notice: 'Subgenre was successfully created.' }
        format.json { render json: @subgenre, status: :created, location: @subgenre }
      else
        format.html { render action: "new" }
        format.json { render json: @subgenre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subgenres/1
  # PUT /subgenres/1.json
  def update
    #raise params.inspect
    @subgenre = Subgenre.find(params[:id])
    if !params[:subgenre]['title'].nil?     
      @subgenre.title = params[:subgenre]['title']
    end

    if !params[:subgenre]['genre'].nil?
      @subgenre.genre = Genre.find(params[:subgenre]['genre'])
    end

    if !params[:subgenre]['subgenre'].nil?
      @subgenre.subgenre = SubgenreUploader.new
      @subgenre.subgenre.store!(params[:subgenre]['subgenre'])
    end

    respond_to do |format|
      if @subgenre.save
        format.html { redirect_to subgenres_path, notice: 'Subgenre was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subgenre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subgenres/1
  # DELETE /subgenres/1.json
  def destroy
    @subgenre = Subgenre.find(params[:id])
    @subgenre.destroy

    respond_to do |format|
      format.html { redirect_to subgenres_url }
      format.json { head :no_content }
    end
  end
end

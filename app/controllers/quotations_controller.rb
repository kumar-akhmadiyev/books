class QuotationsController < ApplicationController
  # GET /quotations
  # GET /quotations.json
  load_and_authorize_resource
  #skip_authorize_resource :only => [:search,:show,:read,:parse_book]
  def index
    @quotations = Quotation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotations }
    end
  end

  # GET /quotations/1
  # GET /quotations/1.json
  def show
    @quotation = Quotation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quotation }
    end
  end

  # GET /quotations/new
  # GET /quotations/new.json
  def new
    @quotation = Quotation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quotation }
    end
  end

  # GET /quotations/1/edit
  def edit
    @quotation = Quotation.find(params[:id])
  end

  # POST /quotations
  # POST /quotations.json
  def create
    @quotation = Quotation.new(params[:quotation])

    respond_to do |format|
      if @quotation.save
        format.html { redirect_to @quotation, notice: 'Quotation was successfully created.' }
        format.json { render json: @quotation, status: :created, location: @quotation }
      else
        format.html { render action: "new" }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quotations/1
  # PUT /quotations/1.json
  def update
    @quotation = Quotation.find(params[:id])

    respond_to do |format|
      if @quotation.update_attributes(params[:quotation])
        format.html { redirect_to @quotation, notice: 'Quotation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/1
  # DELETE /quotations/1.json
  def destroy
    @quotation = Quotation.find(params[:id])
    @quotation.destroy

    respond_to do |format|
      format.html { redirect_to quotations_url }
      format.json { head :no_content }
    end
  end
end

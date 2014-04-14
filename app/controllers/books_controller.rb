class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @books = Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new
    @genres = Genre.all
    @subgenres = Subgenre.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    #raise params.inspect
    @book = Book.new
    @book.title = params[:book]['title']
    @book.description = params[:book]['description']
    @book.subgenre = Subgenre.find(params[:book]['subgenre'])
    @book.bookcover = BookcoverUploader.new
    @book.bookfile = BookfileUploader.new
    @book.bookfile.store!(params[:book]['bookfile'])
    @book.bookcover.store!(params[:book]['bookcover'])

    respond_to do |format|
      if @book.save
        format.html { redirect_to books_path, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /books/1
  # PUT /books/1.json
  def update
    if params[:book]['title']
      @book.title = params[:book]['title']
    end
    if params[:book]['description']
      @book.description = params[:book]['description']
    end
    if params[:book]['subgenre']
      @book.subgenre = Subgenre.find(params[:book]['subgenre'])
    end
    if params[:book]['bookcover']
      @book.bookcover = BookcoverUploader.new
      @book.bookcover.store!(params[:book]['bookcover'])
    end
    if params[:book]['bookfile']
      @book.bookfile = BookfileUploader.new
      @book.bookfile.store!(params[:book]['bookfile'])
    end
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
end

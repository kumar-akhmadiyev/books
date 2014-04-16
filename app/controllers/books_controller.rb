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
    @genres = Genre.all
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
        parse_book @book
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
    change_parsed_book = false
    @book = Book.find(params[:id])
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
      change_parsed_book = true
    end
    respond_to do |format|
      if @book.save
        if (change_parsed_book)
          @book.parsed_book.delete
          parse_book @book
        end
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

  def read
    @book = Book.find(params[:id])
    @page = 1
    @prev = 1
    if !params[:page].nil?
        if params[:page].to_i > 0
          @page = params[:page].to_i
          @prev = @page - 1
        end
    end
    if (@book.parsed_book.pages.count == 0)
      parse_book @book
    end
    @next = [@page+1,@book.parsed_book.pages.count].min
    if (@book.parsed_book.pages.count < @page)
      @text = "Вы пытаетесь открыть несуществующую страницу"
    else
      @text = @book.parsed_book.pages.where(numb: @page).first.text
    end
  end

  protected

  def parse_book book
    #book = Book.find(params[:id])
    xmlbook = Nokogiri::XML(open(book.bookfile.url))
    xmlbook.remove_namespaces!
    text = xmlbook.xpath("//body")[0]
    t = text.xpath("//section")
    t.each do |s|
      if s.keys.empty?
        if (book.parsed_book.nil?)
          book.parsed_book = ParsedBook.new
        end
        book.parsed_book.add_section(s)
      end
    end
  end
end

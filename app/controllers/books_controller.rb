class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  load_and_authorize_resource
  skip_authorize_resource :only => [:search,:show,:read,:parse_book]
  # => load_and_authorize_resource
  def index
    @books = Book.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  def search
    @searched = params
    @books = Book.all
    @authors = Author.all
    if !params[:title].blank?      
      words = params[:title].gsub(/\s+/m, ' ').strip.split(" ")
      
      words.each do |w|
        @books = @books.where(:title => /.*#{w}.*/)     
      end
    end
    if !params[:author].blank?
      @books = @books.where(author: params[:author])
    end
    if !params[:year_from].blank?
      @books = @books.gte(year: params[:year_from].to_i)
    end
    if !params[:year_before].blank?
      @books = @books.lte(year: params[:year_before].to_i)
    end
    @books = @books.order_by(:average_rating.desc)
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    @book.plus_view

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
    @authors = Author.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
    @genres = Genre.all
    @authors = Author.all
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new
    @book.title = params[:book]['title']
    @book.author = Author.find(params[:book]['author'])
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
    if !params[:book]['title'].blank?
      @book.title = params[:book]['title']
    end
    if !params[:book]['year'].blank?
      @book.year = params[:book]['year']
    end
    if !params[:book]['author'].blank?
      @book.author = Author.find(params[:book]['author'])
    end
    if !params[:book]['description'].blank?
      @book.description = params[:book]['description']
    end
    if !params[:book]['subgenre'].blank?
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
    @page = 1     # страница по умолчанию
    @prev = 1     
    if !params[:page].nil?
        if params[:page].to_i > 0
          @page = params[:page].to_i
          @prev = @page - 1
        end
    end
    if (@book.parsed_book.pages.count == 0) # если книга не была распарсена
      parse_book @book #  тогда начать парсинг
    end
    @next = [@page+1,@book.parsed_book.pages.count].min
    if (@book.parsed_book.pages.count < @page)
      @text = "Вы пытаетесь открыть несуществующую страницу"
    else
      @text = @book.parsed_book.pages.where(numb: @page).first.text # вывод страницы
    end
  end

  protected

  def parse_book book
    xmlbook = Nokogiri::XML(open(book.bookfile.url)) # Мы создаем объект класса Nokogiri::XML::Document, в качестве входных данных передаем файл книги
    xmlbook.remove_namespaces! # Удаляем namespaces - лишние проблемы
    text = xmlbook.xpath("//body")[0] # Берем содержимое тэга body - основной части книги
    t = text.xpath("//section") # t - массив из объектов класса Nokogiri::XML::Node, каждый из которых - часть книги
    t.each do |s|     # Пробегаемся по каждой части отдельно
      if s.keys.empty? # Проверка, не является ли секция не основным текстом(сноски, замечания и т.д.)
        if (book.parsed_book.nil?) # Если объект класса parsed_book еще не создан для этой книги
          book.parsed_book = ParsedBook.new # То создаем его
        end
        book.parsed_book.add_section(s) # Передаем в метод класса parsed_book часть книги
      end
    end
  end  
end
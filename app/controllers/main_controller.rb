class MainController < ApplicationController
	def index
		@genres = Genre.all
	end
end

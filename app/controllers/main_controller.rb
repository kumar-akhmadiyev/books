class MainController < ApplicationController
	def index
		@genres = Genre.all
		@s = ENV['S3_KEY']
	end
end

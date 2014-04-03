class Genre
	include Mongoid::Document

	mount_uploader :genrecover, GenrecoverUploader
	attr_accessible :genrecover,:genrecover_cache

	field :title, type: String, default: ""

	has_many :books

end